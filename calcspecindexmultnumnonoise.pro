FUNCTION calcspecindexmultnumnonoise, lambda, flux, num1lo, num1hi, num1weight, num2lo, num2hi, num2weight, denomlo, denomhi, job

;define the regions used to calculate the spectral index
numerator1 = WHERE(lambda GE num1lo AND lambda LE num1hi, nnum1)
totalnum1 = TOTAL(numerator1)
numerator2 = WHERE(lambda GE num2lo AND lambda LE num2hi, nnum2)
totalnum2 = TOTAL(numerator2)
denominator = WHERE(lambda GE denomlo AND lambda LE denomhi, ndenom)
totaldenom = TOTAL(denominator)

;put in a dummy value for if the spectra is too small
index = -9999.
indexdiff = -9999.

;perform the test on if the spectra has the necessary wavelengths, 
;and if so, measure the index
IF ( nnum1 GT 1 AND nnum2 GT 1 AND ndenom GT 1) THEN BEGIN

     ;calculate the weighted mean in the numerator
     nummean1 = MEAN(flux[numerator1])
     nummean2 = MEAN(flux[numerator2])
     combonum = num1weight*nummean1 + num2weight*nummean2
     denmean = MEAN(flux[denominator])

    ;find the noise in the denominator
    dennoise = STDDEV(flux[denominator])

     ;only calculate the index if the denominator has positive flux
     IF (denmean GT 0.) THEN BEGIN
         index = combonum/denmean
         sigmadenmean = dennoise/SQRT(N_ELEMENTS(denominator))
         indexdiff = ABS(index - (combonum/(denmean + sigmadenmean)))
         IF indexdiff LT 0. THEN PRINT, 'HUH?'

     ENDIF
         
ENDIF

IF job EQ 0 THEN RETURN, index ELSE RETURN, indexdiff

END
