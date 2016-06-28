PRO hammer, infile, KEY = key

; make sure user handed an input list!
if N_params() LT 1 then begin
    print,'Error: must pass an input file list:'
    print,'HAMMER, infile [, /key]'
    RETURN
endif


if FILE_TEST(infile) eq 0 then begin
   print,'Error: ' + infile + ' not found!'
   print,'Check the file path and try again.'
   RETURN
endif

;begin by setting parameters for any plots we might make along the way.
SET_PLOT, 'X'
!P.FONT=1
!P.THICK=1
!P.CHARSIZE=1
!P.CHARTHICK=2
!X.THICK=2
!Y.THICK=2


;auto-find the hammer path, based on code from FBEYE by @jradavenport
HAMMER_PATH = file_search(strsplit(!path, path_sep(/search), /extract), 'hammer.pro')
HAMMER_PATH = strmid(hammer_path, 0, strpos(hammer_path, 'code/hammer.pro'))
HAMMER_PATH = HAMMER_PATH[0]

;*** if HAMMER_PATH auto-find doesn't work, manually set the path in this line: ***
;HAMMER_PATH = '/Users/janedoe/idl/TheHammer/'


;check to make sure that the user agrees with this path --
;if they don't allow them to change the path.
PRINT, 'HAMMER_PATH should point to the directory containing '
PRINT, 'hammer.pro and its ancillary programs, as well as '
PRINT, 'indices.idl and templates.idl'
PRINT, 'HAMMER_PATH: ', HAMMER_PATH
hammer_pathcorrect = 'y'
READ, hammer_pathcorrect, PROMPT = 'Is this path correct? (y or n): '
PRINT, ' '

;tell the user how to correct the path if it isn't right for their installation
IF hammer_pathcorrect NE 'y' THEN BEGIN
    PRINT, 'This should not have happened... BUT,'
    PRINT, 'manualy correct HAMMER_PATH by editing hammer.pro '
    PRINT, 'before recompiling and running again.'
    STOP
ENDIF

;Now that we know HAMMER_PATH is correct, create the
;path to the indices.idl and templates.idl files...
INDICES_PATH = HAMMER_PATH + 'resources/indices.idl'
TEMPLATES_PATH = HAMMER_PATH + 'resources/templates.idl'

;check to see if the user wants to set a path to the spectra
spectra_path_prompt = 'y'
READ, spectra_path_prompt, PROMPT = 'Does your input list give the full path to each spectrum? (y or n): '
IF spectra_path_prompt NE 'y' THEN BEGIN
     SPECTRA_PATH = ''
     READ, SPECTRA_PATH, PROMPT = 'Enter the necessary prefix for each files path: '
ENDIF

;check to see if the user wants to run the auto-typing again.
skip_auto_typing = 'n'
READ, skip_auto_typing, PROMPT = 'Skip straight to eyecheck stage? (y or n): '

;enter an if/else statement that allows users to skip right to
;eyecheck if they've run the hammer before
IF skip_auto_typing EQ 'n' THEN BEGIN

    ;ask user if there should be a S/N cut for assigning an auto-type
    use_sn_cut = 'n'
    PRINT, ' '
    PRINT, 'We recommend requiring spectra to have '
    PRINT, 'S/N ~ 3-5 per pixel before assigning types.'
    READ, use_sn_cut, PROMPT = 'Apply S/N cut before assigning automatic type? (y or n): '

    ;if user wants s/n cutoff, set it
    sncutoff = 0
    IF use_sn_cut EQ 'y' THEN BEGIN
        READ, sncutoff, PROMPT = 'Set S/N cutoff: '
    ENDIF

    ;read in the input spectra list
    READCOL, infile, FORMAT = '(A,A)', inlist, ftype, /SILENT
    numfiles = N_ELEMENTS(inlist)

    ;add prefix if necessary
    IF spectra_path_prompt NE 'y' THEN BEGIN
     flist = STRTRIM(SPECTRA_PATH,2)+inlist
    ENDIF ELSE flist = inlist

    ;open idl save file that has spectral type indices
    ;and deviations of the indices with spectral type
    RESTORE, INDICES_PATH
    n_indices = N_ELEMENTS(typeindices[0,*])
    n_indextemps = N_ELEMENTS(typeindices[*,0])

    ;make an array which will later contain the
    ;normalized differences between the indices
    ;measured for each target and the same indices
    ;measured in each of the templates.
    gorydetails = FLTARR(numfiles,n_indextemps,n_indices)

    ;create an array to store the total index difference
    ;for each target - template comparison
    indexmatch = FLTARR(numfiles,n_indextemps)
    bestmatches = INTARR(numfiles)

    ;make an array to change numbers into spectral types
    possibletypes = ['O0','O1','O2','O3','O4','O5','O6','O7','O8','O9','B0','B1','B2','B3','B4','B5','B6','B7','B8','B9','A0','A1','A2','A3','A4','A5','A6','A7','A8','A9','F0','F1','F2','F3','F4','F5','F6','F7','F8','F9','G0','G1','G2','G3','G4','G5','G6','G7','G8','G9','K0','K1','K2','K3','K4','K5','K7','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','L0','L1','L2','L3','L4','L5','L6','L7','L8','L9','T0','T1','T2','T3','T4','T5','T6','T7','T8','T9']

    ;open a file to write spectral type results to
    CLOSE, 2
    OPENW, 2, 'autoSpTresults.tbl'
    PRINTF, 2, 'filename                     fileformat               spec s/n              spectype '

    ;open a file to write spectral type results to
    CLOSE, 3
    OPENW, 3, 'rejectedspectra.tbl'
    PRINTF, 3, 'filename                     s/n'

    ;loop through the files and read in data
    print,'Running ',strtrim(string(numfiles),2),' files...'
    FOR j=0L,numfiles-1 DO BEGIN
        print,j,flist[j]

        ;read in sloan spectra
        IF ftype[j] EQ 'sdssfits' THEN BEGIN
            thisspec = READSLOANSPEC(flist[j])
            waveraw = REFORM(thisspec[0,*])
            fluxraw = REFORM(thisspec[1,*])
            noiseraw = REFORM(thisspec[2,*])
        ENDIF

        ;read in regular fits spectra
        IF ftype[j] EQ 'fits' THEN BEGIN
            thisspec = READPLAINFITS(flist[j])
            waveraw = REFORM(thisspec[0,*])
            fluxraw = REFORM(thisspec[1,*])
            noiseraw = SQRT(fluxraw)
        ENDIF

        ;read in text spectra
        IF ftype[j] EQ 'txt' THEN BEGIN
            READCOL, flist[j], waveraw, fluxraw, /SILENT
            noiseraw = SQRT(fluxraw)
        ENDIF

        ;read in princeton spectra.
        IF ftype[j] EQ 'princeton' THEN BEGIN
            temp=STRSPLIT(flist[j],'-',/extract)
            fplate=FIX(temp[0])
            fmjd=LONG(temp[1])
            ffiber=FIX(temp[2])
            READSPEC,fplate,ffiber,mjd=fmjd,flux=fluxraw,wave=waveraw,invvar=noiseraw
            noiseraw=1./SQRT(noiseraw)

            ;switch to air wavelengths
            VACTOAIR, waveraw

        ENDIF

        ;now interpolate it all onto a uniform 1 Angstrom grid
        wrange = MINMAX(waveraw)
        wmin = FLOAT(FIX(wrange[0])+1.)
        wmax = FLOAT(FIX(wrange[1]))
        wtot = wmax - wmin
        wave = FINDGEN(wtot+1)+wmin
        flux = INTERPOL(fluxraw,waveraw,wave)
        noise = INTERPOL(noiseraw,waveraw,wave)

        ;check in 3 wavelength ranges for the maximum flux
        blue = -1
        yellow = -1
        red = -1
        IF TOTAL(WHERE(wave GT 4500 AND wave LT 4600)) GT -1 THEN blue = MEAN(flux(WHERE(wave GT 4500 AND wave LT 4600)))
        IF TOTAL(WHERE(wave GT 6100 AND wave LT 6200)) GT -1 THEN yellow = MEAN(flux(WHERE(wave GT 6100 AND wave LT 6200)))
        IF TOTAL(WHERE(wave GT 8250 AND wave LT 8350)) GT -1 THEN red = MEAN(flux(WHERE(wave GT 8250 AND wave LT 8350)))

        ;find the maximum flux region
        IF blue GT yellow AND blue GT red THEN BEGIN
            meanflux = blue
            signalregion = WHERE(wave GT 4500 AND wave LT 4600)
            originalsig = STDDEV(flux(signalregion))
        ENDIF
        IF yellow GT blue AND yellow GT red THEN BEGIN
            meanflux = yellow
            signalregion = WHERE(wave GT 6100 AND wave LT 6200)
            originalsig = STDDEV(flux(signalregion))
        ENDIF
        IF red GT blue AND red GT yellow THEN BEGIN
            meanflux = red
            signalregion = WHERE(wave GT 8250 AND wave LT 8350)
            originalsig = STDDEV(flux(signalregion))
        ENDIF

        ;define the signal to noise ratio of
        ;the flux region with the most flux
        firstsn = ABS(meanflux)/ABS(originalsig)

        ; apply the S/N cut if the user wanted it
        ; if user didnt, sncutoff=0, so will run for every star
        IF firstsn GT sncutoff THEN BEGIN

            ;measure indices for comparison to template objects
            targetindices = MEASUREGOODLINES(wave,flux,flist[j],0)
            indicesnoise = MEASUREGOODLINES(wave,flux,flist[j],1)

            ;measure the ratio of the weighted mean wavelength of each
            ;spectrum to the raw mean wavelength
            usewave = WHERE(wave GT 5000 AND wave LT 7750)
            unweightedwave = MEAN(wave[usewave])
            weightedwave = (TOTAL(wave[usewave]*flux[usewave])*1.0)/(TOTAL(flux[usewave]))
            waveratio = weightedwave/unweightedwave

            ;use the weighted wave/mean wave ratio divide objects into
            ;various crude spectral type ranges, and eliminate indices
            ;that aren't appropriate for that spectral type range.

            ;identify likely M and later dwarfs (eliminate blue indices!)
            IF waveratio GE 1.03 THEN bad = [0,1,3,4,5,6,7,8,10,11,12,24,27,29]

            ;find likely late F, G, and K types.
            ;eliminate all the late M/L indices,
            ;but don't use blue color quite yet...
            IF waveratio GE 0.97 AND waveratio LT 1.03 THEN bad = [1,7,29]    ;[1,4,5,7,8,10,12,29]
            IF waveratio LT 0.97 THEN bad = [2,10,15,16,17,18,19,21,22,23,24,25,26,27,28,29]

            ;set the inappropriate indices to -9999.
            targetindices[bad] = -9999.

            ;now find indices that are in regions
            ;the spectra doesn't cover or that appear
            ;inappropriate for this type of object
            settoone = WHERE(targetindices GT -9998.)

            ;now compare to indices for each template, dividing the difference
            ;in index strength between template and target by the noise in the
            ;template index, and summing the results for each spectral type
            IF TOTAL(settoone) NE -1 THEN BEGIN

                 FOR l=0,n_indextemps-1 DO BEGIN
                    gorydetails[j,l,*] = -9999.
                    diff = targetindices[settoone] - REFORM(typeindices[l,settoone])
                    normalizer = indicesnoise[settoone]
                    normdiff = diff / normalizer
                    squarediff = normdiff^2.
                    gorydetails[j,l,settoone] = squarediff
                    meandiff = MEAN(squarediff)
                    indexmatch[j,l] = meandiff
                ENDFOR

                ;find the minimum residuals
                bestmatch = SORT(indexmatch[j,*])
                bestmatches[j] = bestmatch[0]
                printtype = possibletypes[bestmatches[j]]

                ;print the results into autoSpTresults.tbl
                PRINTF, 2, FORMAT = '(A100,2x,A10,2x,F10.4,2x,A2)', inlist[j], ftype[j], firstsn, printtype

            ENDIF ELSE firstsn = -99.

        ENDIF ELSE PRINTF, 3, FORMAT = '(A100,2x,A10,2x,F10.4)', inlist[j], ftype[j], firstsn

        IF firstsn EQ -99. THEN PRINTF, 3, FORMAT = '(A100,2x,A10,2x,F10.4)', inlist[j], ftype[j], firstsn

    ENDFOR

    CLOSE, 2
    CLOSE, 3

    ;now measure the ew and subdwarf stuff with andrew's code
    EW, spectra_path_prompt, SPECTRA_PATH

ENDIF

;allow the user to do an eyecheck
IF KEYWORD_SET(key) THEN $
    EYECHECK_KEY, TEMPLATES_PATH, spectra_path_prompt, SPECTRA_PATH ELSE EYECHECK, TEMPLATES_PATH, spectra_path_prompt, SPECTRA_PATH

print,'HAMMER is complete'
RETURN
END
