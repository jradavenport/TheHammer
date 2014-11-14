FUNCTION readplainfits,filename   ;this function takes in the name of a keck-style 
                                        ;spectra fits file and returns a 3 by X array
                                        ;called datastructure, where X is the number
                                        ;of data points measured.  datastructure(0,*)
                                        ;gives the wavelength information, (1,*) gives
                                        ;flux, and (2,*) gives noise information.
 
        data = READFITS(filename,header,/SILENT)        ;read data into data, header into header
        baselambda = SXPAR(header,'CRVAL1')     ;find the starting wavelength of the spectrum
        basepixel = SXPAR(header,'CRPIX1')      ;find the location of the reference pixel

        checkstep = -99
        step = SXPAR(header,'CD1_1', count = checkstep)            ;find how big the wavelength step is
        IF checkstep EQ 0 THEN step = SXPAR(header, 'CDELT1')

        IF basepixel NE 1 THEN BEGIN      ;allow for spectra with wavelength solutions that are not defined on the first pixel 
            baselambda = baselambda+step*(1-basepixel)
        ENDIF

        PRINT, baselambda, basepixel, step


        nsteps = N_ELEMENTS(data[*,0])          ;find the # of pixels in the spectra
        lambda = baselambda+FINDGEN(nsteps)*1.0*step  ;now create an array for the wavelength values...
        flux = REFORM(data[*,0])                        ;pick off the flux values
        error = FLTARR(nsteps)          ;since our code is dependent on having values for the
        error[*] = -99.                    ;noise, we'll just have to make some!
 
        datastructure = DBLARR(3,nsteps)
        datastructure[0,*] = lambda
        datastructure[1,*] = flux
        datastructure[2,*] = error

;        PLOT, lambda, flux

        RETURN,datastructure

END
 
;---------------------------------------------------------
