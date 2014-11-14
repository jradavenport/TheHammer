PRO EYECHECK, template_path, spectra_path_prompt, spectra_path
CLOSE, 1 

!P.FONT=1
!P.THICK=1
!P.CHARSIZE=2
!P.CHARTHICK=2
!X.THICK=2
!Y.THICK=2

SET_PLOT, 'X'
LOADCT, 39, /SILENT
!P.MULTI=[0,1,1]
WINDOW, XSIZE = 800, YSIZE = 500

;make up a big string array containing all the buttons we'll need for
;the human interaction
ubertypebuttons = ['O','B','A','F','G','K','M','L']
specbuttons = STRARR(8,10)
specbuttons[0,*] = ['O0','O1','O2','O3','O4','O5','O6','O7','O8','O9']
specbuttons[1,*] = ['B0','B1','B2','B3','B4','B5','B6','B7','B8','B9']
specbuttons[2,*] = ['A0','A1','A2','A3','A4','A5','A6','A7','A8','A9']
specbuttons[3,*] = ['F0','F1','F2','F3','F4','F5','F6','F7','F8','F9']
specbuttons[4,*] = ['G0','G1','G2','G3','G4','G5','G6','G7','G8','G9']
specbuttons[5,*] = ['K0','K1','K2','K3','K4','K5','K6','K7','K8','K9']
specbuttons[6,*] = ['M0','M1','M2','M3','M4','M5','M6','M7','M8','M9']
specbuttons[7,*] = ['L0','L1','L2','L3','L4','L5','L6','L7','L8','L9']

options = INTARR(8,10)
options[0,*] = [5,5,5,5,5,5,7,7,8,9]
options[1,*] = [0,1,1,3,3,5,6,7,8,9]
options[2,*] = [0,1,2,3,4,5,6,7,9,9]
options[3,*] = [0,1,2,3,4,5,6,7,8,9]
options[4,*] = [0,1,2,3,4,5,6,7,8,9]
options[5,*] = [0,1,2,3,4,5,7,7,5,4]
options[6,*] = [0,1,2,3,4,5,6,7,8,9]
options[7,*] = [0,1,2,3,4,5,6,7,8,8]

permbuttons = STRARR(6)
permbuttons = ['ODD','BAD','SMOOTH','DONE','BACK','BREAK']

smoothbuttons = ['1','3','7','11','15','19','23','31','39','49']
smoothnum = [1,3,7,11,15,19,23,31,39,49]

specxs = [4100, 4700, 5300, 5900, 6500, 7100, 7700, 8300, 8900, 9500]
specys = [5.1, 5.1, 5.1, 5.1, 5.1, 5.1, 5.1, 5.1, 5.1, 5.1]

uberxs = [3500,3500,3500,3500,3500,3500,3500,3500]
uberys = [4.25,3.75,3.25,2.75,2.25,1.75,1.25,0.75]

permxs = [3500,4500,5500,6500,7500,8500]
permys = [-0.5,-0.5,-0.5,-0.5,-0.5,-0.5]

plusminus = ['EARLIER','LATER']
plusminusx = [9650,9650]
plusminusy = [3.5, 1.5]

type = -1977                  
nlines = NUMLINES('autoSpTresults.tbl')-1
IF FILE_TEST('eyeout.tbl') EQ 1 THEN nfile = NUMLINES('eyeout.tbl') ELSE nfile = 0
datacut = 'y'

PRINT, ' '
READ, datacut, prompt = 'Should we require a S/N cut for typing by eye? (reply y or n): '
PRINT, ' '

sncutoff = 00.01
IF datacut EQ 'y' THEN BEGIN
    READ, sncutoff, PROMPT = 'S/N level to use for cutoff: '
ENDIF

PRINT, 'there are ',strtrim(nlines,2), ' spectra to examine'
PRINT, 'Your Outfile has ',strtrim(nfile,2),' lines in it. We suggest starting at spectrum number ',strtrim(nfile,2),' (remember the spectra start at 0.)'
READ, srt, prompt = 'At what spectrum would you like to begin? '
PRINT, ' '
  
IF (srt EQ 0) THEN BEGIN
    CLOSE, 1
    OPENW, 1, 'eyeout.tbl'
ENDIF ELSE BEGIN
    CLOSE, 1
    OPENU, 1 , 'eyeout.tbl',/append
ENDELSE 
  
READCOL, 'autoSpTresults.tbl',infile,format,spectrasn,stringtype, Format = 'A,A,F,A', SKIPLINE = 1, /SILENT
 
;add prefix if necessary
IF spectra_path_prompt NE 'y' THEN BEGIN
     file = STRTRIM(SPECTRA_PATH,2)+infile
ENDIF ELSE file = infile

RESTORE, template_path

possibletypes = ['O0','O1','O2','O3','O4','O5','O6','O7','O8','O9','B0','B1','B2','B3','B4','B5','B6','B7','B8','B9','A0','A1','A2','A3','A4','A5','A6','A7','A8','A9','F0','F1','F2','F3','F4','F5','F6','F7','F8','F9','G0','G1','G2','G3','G4','G5','G6','G7','G8','G9','K0','K1','K2','K3','K4','K5','K7','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','L0','L1','L2','L3','L4','L5','L6','L7','L8','L9','T0','T1','T2','T3','T4','T5','T6','T7','T8','T9']
templatetoshow = [0,0,0,0,0,0,1,1,2,3,4,5,5,6,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,66,66,66,66,66,66,66,66,66,66,66]

i=LONG(srt)
WHILE i LT nlines DO BEGIN

        IF i EQ 10*(FIX(i/10.)) THEN BEGIN
            CLOSE, 1
            OPENU, 1 , 'eyeout.tbl',/append
        ENDIF

        forsmooth = 1
        newtargetsmooth = 0

        ;read in regular sloan spectra
        IF format[i] EQ 'sdssfits' THEN BEGIN
            data = READSLOANSPEC(file(i))
            wave = data(0,*)
            flux = data(1,*)
        ENDIF

        ;read in regular fits spectra
        IF format[i] EQ 'fits' THEN BEGIN
            thisspec = READPLAINFITS(file[i])
            wave = REFORM(thisspec[0,*])
            flux = REFORM(thisspec[1,*])
        ENDIF

        ;read in text spectra
        IF format[i] EQ 'txt' THEN BEGIN
            READCOL, file[i], wave, flux, /SILENT
        ENDIF

        ;read in princeton fits
        IF format[i] EQ 'princeton' THEN BEGIN
           temp=STRSPLIT(file[i],'-',/extract)
           fplate=FIX(temp[0])
           fmjd=LONG(temp[1])
           ffiber=FIX(temp[2])
           READSPEC,fplate,ffiber,mjd=fmjd,flux=flux,wave=wave
        ENDIF

        IF datacut EQ 'n' THEN spectrasn[i] = sncutoff+1.

        ;;;;;Here is where the signal-to noise cut is set

        IF (spectrasn[i] GT sncutoff) THEN BEGIN
   
            ;now pick an appropriate spectra for
            ;comparison with this object, remembering both
            ;the initial guess, as well as the type of the closest 
            ;template we actually have to display

            firststringtype = stringtype[i]
            guessmatch = WHERE(stringtype[i] EQ possibletypes)
            firstguess = guessmatch
            IF guessmatch LT 56 THEN BEGIN
                buttoncoord1 = (guessmatch)/10
                buttoncoord2 = guessmatch - ( (guessmatch)/10 )*10
            ENDIF ELSE BEGIN
                IF guessmatch EQ 56 THEN BEGIN
                    buttoncoord1 = (guessmatch)/10
                    buttoncoord2 = guessmatch + 1 - ( (guessmatch)/10 )*10
                ENDIF ELSE BEGIN
                    buttoncoord1 = (guessmatch+3)/10
                    buttoncoord2 = guessmatch + 3 - ( (guessmatch+3)/10 )*10
                ENDELSE
            ENDELSE

            ;PRINT, guessmatch, buttoncoord1, buttoncoord2, stringtype[i]

            IF guessmatch NE -1 THEN BEGIN
                firstwave2 = REFORM(templatearray[templatetoshow[guessmatch],0,*])
                firstflux2 = REFORM(templatearray[templatetoshow[guessmatch],1,*])
                usabletemp = WHERE(firstflux2 GT -99999.)
                wave2 = firstwave2[usabletemp]
                flux2 = firstflux2[usabletemp]
                displayingnum = templatearray[templatetoshow[guessmatch],2,0]
                displayingtext = possibletypes[displayingnum]

                ;now figure out how to normalize the two spectra to 
                ;one another, keeping in mind that they might have vastly
                ;different wavelength ranges -- just rangematch and normalize
                ;the means of the overlapping areas.
                scalefactors = SCALER(wave,flux,wave2,flux2)
                normflux1 = flux/scalefactors[0]
                normflux2 = flux2/scalefactors[1]
                type = guessmatch
                class = possibletypes[type]

                PLOT, wave,normflux1,XRANGE=[3800,9500],YRANGE=[0,5], /XSTY, /YSTY, XMARGIN = [6,10]
                OPLOT, wave2,normflux2,COLOR=225, LINESTYLE = 2
                EYELEGEND,['First Guess: ' + possibletypes[firstguess],'Current Guess: ' + STRTRIM(possibletypes[type],2),'Current Template: ' + STRTRIM(displayingtext,2)], POS=[.15,.95], CHARSIZE = 1.5, BOX = 0
                EYELEGEND, ['file #: '+STRTRIM(STRING(FIX(i)),2),'file: '+STRTRIM(file[i],2)], POS=[.5,.95], BOX=0, CHARSIZE = 1.5
                XYOUTS, specxs, specys, specbuttons[buttoncoord1,*]
                FOR k=0,9 DO XYOUTS, specxs[options[buttoncoord1,k]],specys[options[buttoncoord1,k]], specbuttons[buttoncoord1,options[buttoncoord1,k]], COLOR = 150
                XYOUTS, specxs[buttoncoord2], specys[buttoncoord2], specbuttons[buttoncoord1,buttoncoord2], COLOR = 225
                XYOUTS, uberxs, uberys, ubertypebuttons
                XYOUTS, uberxs[buttoncoord1], uberys[buttoncoord1], ubertypebuttons[buttoncoord1], COLOR = 225
                XYOUTS, permxs, permys, permbuttons
                XYOUTS, plusminusx, plusminusy, plusminus

                j=0
                WHILE (j EQ 0) DO BEGIN
                    curx = -99
                    cury = -99

                    CURSOR, curx, cury, /DOWN, /DATA
                 
                    IF cury GE .3 AND cury LE 4.7 AND curx LT 4000 THEN BEGIN
                        distances = ABS(cury - uberys) 
                        closest = MIN(distances,buttoncoord1)
                    ENDIF
             
                    IF cury LT 4.7 AND cury GE 2.5 AND curx GT 9500 THEN BEGIN
                        IF buttoncoord1 EQ 0 AND buttoncoord2 EQ 0 THEN BEGIN
                           buttoncoord1 = buttoncoord1
                           buttoncoord2 = buttoncoord2
                        ENDIF ELSE BEGIN
                            buttoncoord2 = buttoncoord2-1
                            IF buttoncoord2 EQ -1 THEN BEGIN 
                                buttoncoord2 = 9
                                buttoncoord1 = buttoncoord1-1
                            ENDIF
                        ENDELSE
                    ENDIF

                    IF cury LT 2.5 AND cury GE 0.3 AND curx GT 9500 THEN BEGIN
                       IF buttoncoord1 EQ 7 AND buttoncoord2 EQ 9 THEN BEGIN
                           buttoncoord1 = buttoncoord1
                           buttoncoord2 = buttoncoord2
                       ENDIF ELSE BEGIN
                           buttoncoord2 = buttoncoord2+1
                           IF buttoncoord2 EQ 10 THEN BEGIN 
                               buttoncoord2 = 0
                               buttoncoord1 = buttoncoord1+1
                           ENDIF
                       ENDELSE
                    ENDIF

                    IF cury GT 4.7 THEN BEGIN
                        prevbutton2 = buttoncoord2
                        distances = ABS(curx - specxs)
                        closest = MIN(distances, buttoncoord2)         
                    ENDIF

                    IF cury LT 0 AND cury GT -98 THEN BEGIN
                        IF curx LT 4100 THEN BEGIN
                            type = -2
                        ENDIF

                        IF curx GE 4100 AND curx LT 5100 THEN BEGIN
                            type = -1 
                            class = 'bad'
                        ENDIF
                        IF curx GE 5100 AND curx LT 6200 THEN BEGIN
                            newtargetsmooth = 1
                        ENDIF
                        IF curx GE 6200 AND curx LT 7100 THEN BEGIN
                            class = possibletypes[type]
                            type = -1
                        ENDIF  
                        IF curx GE 7100 AND curx LT 8100 THEN BEGIN
                            ;PRINT, FORMAT='(I5,2x,I5,2x,A10,2x,A10,2x,A10)', i, j, type, class , 'check1'
                            IF i NE 0 THEN type = -3 ELSE PRINT, 'Nowhere to go back to!'
                            ;PRINT, FORMAT='(I5,2x,I5,2x,A10,2x,A10,2x,A10)', i, j, type, class, 'check2'
                        ENDIF
                     
                        IF curx GE 8100 THEN BEGIN
                            type = 100
                        ENDIF
                    ENDIF

                    IF (type EQ 100) THEN BEGIN
                         PRINT, FORMAT = '(A30,2x,I5)', 'Your last spectrum was number ', i-1
                         CLOSE, 1
                         STOP
                    ENDIF
  
                    IF (type GT -1) THEN BEGIN

                        IF newtargetsmooth EQ 1 THEN BEGIN

                            smoothindex = 0

                            PLOT, wave, normflux1, XRANGE=[3800,9500],YRANGE=[0,5], /XSTY, /YSTY, XMARGIN = [6,10]
                            OPLOT, wave2,normflux2,COLOR=225, LINESTYLE = 2
                            EYELEGEND,['First Guess: ' + possibletypes[firstguess],'Current Guess: ' + STRTRIM(possibletypes[type],2),'Current Template: ' + STRTRIM(displayingtext,2)], POS=[.15,.95], CHARSIZE = 1.5, BOX = 0
                            EYELEGEND, ['file #: '+STRTRIM(STRING(FIX(i)),2),'file: '+STRTRIM(file[i],2)], POS=[.5,.95], BOX=0, CHARSIZE = 1.5
                            XYOUTS, specxs, specys, smoothbuttons, COLOR = 150
                            XYOUTS, uberxs, uberys, ubertypebuttons
                            XYOUTS, uberxs[buttoncoord1], uberys[buttoncoord1], ubertypebuttons[buttoncoord1], COLOR = 225
                            XYOUTS, permxs, permys, permbuttons
                            XYOUTS, plusminusx, plusminusy, plusminus

                            CURSOR, curx, cury, /DOWN, /DATA
                            distances = ABS(curx - specxs) 
                            closest = MIN(distances,smoothindex)

                            forsmooth = smoothnum[smoothindex]

                            IF format[i] EQ 'sdssfits' THEN BEGIN
                                 data = READSLOANSPEC(file(i))
                                 wave = data(0,*)
                                 flux = data(1,*)
                            ENDIF

                            ;read in regular fits spectra
                            IF format[i] EQ 'fits' THEN BEGIN
                                 thisspec = READPLAINFITS(file[i])
                                 wave = REFORM(thisspec[0,*])
                                 flux = REFORM(thisspec[1,*])
                            ENDIF

                            ;read in text spectra
                            IF format[i] EQ 'txt' THEN BEGIN
                                 READCOL, file[i], wave, flux, /SILENT
                            ENDIF

                            ;smooth the target spectra 
                            flux = SMOOTH(flux, forsmooth,/EDGE_TRUNCATE)

                            newtargetsmooth = 0 
                        ENDIF

                        thisone = WHERE(possibletypes EQ (specbuttons[buttoncoord1,buttoncoord2])[0] )
                        IF TOTAL(thisone) NE -1 AND N_ELEMENTS(thisone) EQ 1 THEN type = thisone
                         
                        ;PRINT, buttoncoord1, buttoncoord2, type, thisone, possibletypes[type], templatetoshow[type]

                        firstwave2 = REFORM(templatearray[templatetoshow[type],0,*])
                        firstflux2 = REFORM(templatearray[templatetoshow[type],1,*])
                        usabletemp = WHERE(firstflux2 GT -99999.)
                        wave2 = firstwave2[usabletemp]
                        flux2 = firstflux2[usabletemp]
                        flux2 = SMOOTH(flux2, forsmooth, /EDGE_TRUNCATE)
                        displayingnum = templatearray(templatetoshow[type],2,0)
                        displayingtext = possibletypes[displayingnum]

                        ;now figure out how to normalize the two spectra to 
                        ;one another, keeping in mind that they might have vastly
                        ;different wavelength ranges -- just rangematch and normalize
                        ;the means of the overlapping areas.
                        scalefactors = SCALER(wave,flux,wave2,flux2)
                        normflux1 = flux/scalefactors[0]
                        normflux2 = flux2/scalefactors[1]

                        PLOT, wave,normflux1,XRANGE=[3800,9500],YRANGE=[0,5], /XSTY, /YSTY, XMARGIN = [6,10]
                        OPLOT, wave2,normflux2,COLOR=225, LINESTYLE = 2
                        EYELEGEND,['First Guess: ' + possibletypes[firstguess],'Current Guess: ' + STRTRIM(possibletypes[type],2),'Current Template: ' + STRTRIM(displayingtext,2)], POS=[.15,.95], CHARSIZE = 1.5, BOX = 0
                        EYELEGEND, ['file #: '+STRTRIM(STRING(FIX(i)),2),'file: '+STRTRIM(infile[i],2)], POS=[.5,.95], BOX=0, CHARSIZE = 1.5
                        XYOUTS, specxs, specys, specbuttons[buttoncoord1,*]
                        FOR k=0,9 DO XYOUTS, specxs[options[buttoncoord1,k]],specys[options[buttoncoord1,k]], specbuttons[buttoncoord1,options[buttoncoord1,k]], COLOR = 150
                        XYOUTS, specxs[buttoncoord2], specys[buttoncoord2], specbuttons[buttoncoord1,buttoncoord2], COLOR = 225
                        XYOUTS, uberxs, uberys, ubertypebuttons
                        XYOUTS, uberxs[buttoncoord1], uberys[buttoncoord1], ubertypebuttons[buttoncoord1], COLOR = 225
                        XYOUTS, permxs, permys, permbuttons
                        XYOUTS, plusminusx, plusminusy, plusminus

                    ENDIF ELSE BEGIN
                               IF type EQ -1 THEN BEGIN
                                   PRINTF, 1, FORMAT = '(A90,2x,A3,2x,A3)',infile[i],class, stringtype[i]
                                   j=1
                               ENDIF 

                               IF type EQ -2 THEN BEGIN
                                   READ, class, PROMPT = '3 letter code for odd object: '
                                   PRINTF, 1, FORMAT = '(A90,2x,A3,2x,A3)',infile[i],class, stringtype[i]
                                   j=1
                               ENDIF

                               ;allow the user to go 
                               IF type EQ -3 THEN BEGIN
                                   CLOSE, 1
                                   READCOL, 'eyeout.tbl', FORMAT = '(A,A,A)',oldnames,oldtypes, oldstringtype, /SILENT
                                   redo = N_ELEMENTS(oldnames)
                                   ;PRINT, FORMAT='(I5,2x,I5,2x,A10,2x,A10,2x,I5,2x,A10)', i, j, type, class, redo, 'check3' 
                                   OPENW, 1, 'eyeout.tbl'
                                   FOR m=0,redo-2 DO BEGIN
                                       PRINTF, 1, FORMAT = '(A100,2x,A3,2x,A3)',oldnames[m],oldtypes[m], oldstringtype[m]
                                       ;PRINT, FORMAT = '(A90,2x,A3,2x,A3)',oldnames[m],oldtypes[m], oldstringtype[m]
                                   ENDFOR
                                   i = redo-2
                                   j=20
                                   ;PRINT, FORMAT='(I5,2x,I5,2x,A10,2x,A10,2x,I5,A10)', i, j, type, class, redo, 'check4'
                               ENDIF
                    ENDELSE
                ENDWHILE 
            ENDIF
        ENDIF ELSE BEGIN
            class = 'S/N'
            PRINTF, 1, FORMAT = '(A100,2x,A3,2x,A3)', infile[i], class, stringtype[i]
        ENDELSE
        i=i+1
ENDWHILE

CLOSE, 1

;now unify eyeout.dat and ew.dat

READCOL, 'eyeout.tbl', FORMAT='(A,A,A)', eyename, eyetype, original, /SILENT

READCOLMORE, 'ew.tbl', FORMAT='(A,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,F,A)',ewname,ewHa, ewerr,diff,Tio5,Tio5err,CaH1,CaH1err,CaH2,CaH2err,CaH3,CaH3err,tio8,tio8err,ti05_u_test,tio5_l_test,cah1_u_test,cah1_l_test,cah2_u_test,cah2_l_test,cah3_u_test,cah3_l_test,ti08_u_test,tio8_l_test,hacont,haconterr,sig2noise,type, /SILENT

;writeout after testing that both lists have the same number of
;objects

neyeout = N_ELEMENTS(eyename)
new = N_ELEMENTS(ewname)

IF neyeout EQ new THEN BEGIN
    CLOSE, 3
    OPENW, 3, 'finalsummary.tbl'
    PRINTF, 3, FORMAT='(a100,2x,A7,2x,A7,2x,26(1x,A15),a5)', 'eyename', 'SpT', 'autoSpT','ewHa', 'ewerr','diff','Tio5','Tio5err','CaH1','CaH1err','CaH2','CaH2err','CaH3','CaH3err','tio8','tio8err','ti05_u_test','tio5_l_test','cah1_u_test','cah1_l_test','cah2_u_test','cah2_l_test','cah3_u_test','cah3_l_test','ti08_u_test','tio8_l_test','hacont','haconterr','sig2noise','type'
    FOR i = 0, neyeout-1 DO BEGIN
        IF ewname[i] EQ eyename[i] THEN BEGIN
            PRINTF, 3, FORMAT='(a100,2x,A3,2x,A3,2x,26(1x,f15.7),a5)', eyename[i], eyetype[i], original[i], ewHa[i], ewerr[i],diff[i],Tio5[i],Tio5err[i],CaH1[i],CaH1err[i],CaH2[i],CaH2err[i],CaH3[i],CaH3err[i],tio8[i],tio8err[i],ti05_u_test[i],tio5_l_test[i],cah1_u_test[i],cah1_l_test[i],cah2_u_test[i],cah2_l_test[i],cah3_u_test[i],cah3_l_test[i],ti08_u_test[i],tio8_l_test[i],hacont[i],haconterr[i],sig2noise[i],type[i]
        ENDIF  
    ENDFOR
    CLOSE, 3
ENDIF ELSE BEGIN
    PRINT, 'ew.tbl and eyeout.tbl have different lengths'
    PRINT, 'files cannot be merged.'
ENDELSE

end

