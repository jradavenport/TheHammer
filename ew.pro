PRO ew, spectra_path_prompt, spectra_path
LOADCT, 12

;open a file to write results to
CLOSE, 1
OPENW, 1 ,'ew.tbl'

;read in files that met the automatic signal to noise cut and got a
;type from hammer.pro
READCOL, 'autoSpTresults.tbl',FORMAT='(A,A,F,A)',inlist, ftype, firstsn, printtype

;add prefix if necessary
IF spectra_path_prompt NE 'y' THEN BEGIN
     flist = STRTRIM(SPECTRA_PATH,2)+inlist
ENDIF ELSE flist = inlist

;look at all the spectra in turn
FOR i = 0L, N_ELEMENTS(flist) - 1 do begin

    ;check the format of the spectra
    ;and read in appropriately

    ;read in sloan spectra 
    IF ftype[i] EQ 'sdssfits' THEN BEGIN
        thisspec = READSLOANSPEC(flist[i])
        waveraw = REFORM(thisspec[0,*])
        fluxraw = REFORM(thisspec[1,*])
        noiseraw = REFORM(thisspec[2,*])        
    ENDIF

    ;read in regular fits spectra
    IF ftype[i] EQ 'fits' THEN BEGIN
        thisspec = READPLAINFITS(flist[i])
        waveraw = REFORM(thisspec[0,*])
        fluxraw = REFORM(thisspec[1,*])
        noiseraw = SQRT(fluxraw)
        noiseraw[*] = -9999.
    ENDIF

    ;read in text spectra
    IF ftype[i] EQ 'txt' THEN BEGIN
        READCOL, flist[i], waveraw, fluxraw, /SILENT
        noiseraw = SQRT(fluxraw)
        noiseraw[*] = -9999.
    ENDIF

    IF ftype[i] EQ 'princeton' THEN BEGIN
        temp=STRSPLIT(flist[i],'-',/extract)
        fplate=FIX(temp[0])
        fmjd=LONG(temp[1])
        ffiber=FIX(temp[2])
        READSPEC,fplate,ffiber,mjd=fmjd,flux=fluxraw,wave=waveraw,invvar=noiseraw
        noiseraw=1./SQRT(noiseraw)
    ENDIF

    ;convert all spectra from air to vacuum wavelengths
    ;(remember that READSLOANFITS converts from the natural
    ;sloan wavelengths into air before returning the wavelength array)
    AIRTOVAC, waveraw

    ;use a modified version of the subdwarf program to measure
    ;important molecular bands
    ;bands are
    ; [Tio5,Tio5err,CaH1,CaH1err,CaH2,CaH2err,CaH3,CaH3err,tio8,tio8err,ti05_u_test,tio5_l_test,cah1_u_test,cah1_l_test,cah2_u_test,cah2_l_test,cah3_u_test,cah3_l_test,ti08_u_test,tio8_l_test]

    bands = SUBDWARF(waveraw,fluxraw,noiseraw)

    IF TOTAL(WHERE(waveraw GT 6557.61 AND waveraw LT 6571.61)) NE -1 AND TOTAL(WHERE(waveraw GT 6500 AND waveraw LT 6550)) NE -1 AND TOTAL(WHERE(waveraw GT 6575 AND waveraw LT 6625)) NE -1 THEN BEGIN
    calcwaves_a = waveraw(WHERE(waveraw GT 6557.61 AND waveraw LT 6571.61))
    calcflux_a = fluxraw(WHERE(waveraw GT 6557.61 AND waveraw LT 6571.61))
    calcerr = noiseraw(WHERE(waveraw GT 6557.61 AND waveraw LT 6571.61))   

    noisef1 = fluxraw(WHERE(waveraw GT 6500 and waveraw LT 6550))
    noisew1 = waveraw(WHERE(waveraw GT 6500 and waveraw LT 6550))
    noisef2 = fluxraw(WHERE(waveraw GT 6575 and waveraw LT 6625))
    noisew2 = waveraw(WHERE(waveraw GT 6575 and waveraw LT 6625))
    noisee1 = noiseraw(WHERE(waveraw GT 6500 and waveraw LT 6550)) 
    noisee2 = noiseraw(WHERE(waveraw GT 6575 and waveraw LT 6625)) 
ENDIF ELSE BEGIN
    calcwaves_a = -9999.
    calcflux_a =  -9999.
    calcerr =  -9999.

    noisef1 =  -9999.
    noisew1 =  -9999.
    noisef2 =  -9999.
    noisew2 =  -9999.
    noisee1 =  -9999.
    noisee2 =  -9999.

ENDELSE


    vec = [noisef1,noisef2]
    errvec = [noisee1,noisee2]  
    std = STDDEV(vec)
    meanf = MEAN(vec)
    sig2noise = 1./(meanf/std)
    Diff = (MAX(calcflux_a)-MIN(calcflux_a))/std

    hacont = vec
    haconterr = errvec
    check = N_ELEMENTS(hacont)
    IF (check GT 1) THEN BEGIN
        hacont = MEAN(hacont)
        haconterr = SQRT(TOTAL(haconterr^2.0))/check
    ENDIF

    fluxnorm = MEAN(noisef1)
    fluxnorm2 = MEAN(noisef2)
    fluxnormerr1 = (noisee1)^2.0   
    fluxnormerr2 = (noisee2)^2.0   
    meanfluxnorm = (fluxnorm + fluxnorm2)/2.0

    n_e = N_ELEMENTS(fluxnormerr1)   
    n_e2 = N_ELEMENTS(fluxnormerr2)  
    meanfluxnormerr = (TOTAL(fluxnormerr1)+TOTAL(fluxnormerr2))/(2.0*(n_e+n_e2))^2.0
  
    n_a = N_ELEMENTS(calcwaves_a)
  
    tot_a = 0
    tot_err = 0   

    FOR j = 0, n_a-2 DO BEGIN
        int_a = ((calcflux_a(j)+calcflux_a(j+1))/2.0-meanfluxnorm)*(calcwaves_a(j+1)-calcwaves_a(j))
        int_err = (((calcerr(j))^2.0+(calcerr(j+1))^2.0)/4.0*((calcwaves_a(j+1)-calcwaves_a(j)))^2.0)^(0.5)   
        tot_a = int_a + tot_a
        tot_err = ((int_err)^2.0 + (tot_err)^2.0)^(0.5)   
    ENDFOR

    ewHa = tot_a/meanfluxnorm

    ewerr = SQRT((tot_err/meanfluxnorm)^2.0+(tot_a)^2.0*(meanfluxnormerr)/meanfluxnorm^4.0)  
  
    IF (meanfluxnorm LT 0.0) THEN BEGIN
        diff = 1
    ENDIF

    IF noiseraw[0] EQ -9999. THEN ewerr = ewHa - 1.

    IF (ewHa GT 1.0 AND diff GT 3.0 AND ewHa GT ewerr ) THEN BEGIN
        type = 'y'
    ENDIF ELSE BEGIN 
        IF (ewHa GT 1.0 AND diff GT 2.0 AND diff LT 3.0 AND ewHa GT ewerr ) THEN BEGIN
            type = 'm'
        ENDIF ELSE BEGIN 
            IF (ewHa GT 0.0 and ewHa LT 1.0 and diff GT 2.0 and ewHa GT ewerr ) THEN BEGIN
                type = 'w'
            ENDIF ELSE BEGIN 
                type = 'n'
            ENDELSE
        ENDELSE
    ENDELSE

    IF noiseraw[0] EQ -9999. THEN ewerr = -9999.

    PRINTF, 1, inlist[i],ewHa, ewerr,diff,bands(0),bands(1),bands(2),bands(3),bands(4),bands(5),bands(6),bands(7),bands(8),bands(9),bands(10),bands(11),bands(12),bands(13),bands(14),bands(15),bands(16),bands(17),bands(18),bands(19),hacont,haconterr,sig2noise,type,format= '(a100,26(1x,f15.7),a5)'

ENDFOR

CLOSE,1  

END






