FUNCTION calcspecindexnonoise, lambda, flux, numlo, numhi, denomlo, denomhi, job

;define the regions used to calculate the spectral index
numerator = WHERE(lambda GE numlo AND lambda LE numhi,nnum)
totalnum = TOTAL(numerator)
denominator = WHERE(lambda GE denomlo AND lambda LE denomhi, ndenom)
totaldenom = TOTAL(denominator)

;put in a dummy value for if the spectra is too small
index = -9999.
indexdiff = -9999.

;perform the test on if the spectra has the necessary wavelengths, 
;and if so, measure the index
IF ( nnum GT 1 AND ndenom GT 1 ) THEN BEGIN

    ;find the noise in the denominator
    dennoise = STDDEV(flux[denominator])

    ;calculate the mean in each bandpass
    nummean = MEAN(flux[numerator])
    denmean = MEAN(flux[denominator])

    ;only calculate the index if the denominator has positive flux
    IF (denmean[0] GT 0.) THEN BEGIN
        index = nummean/denmean
        sigmadenmean = dennoise/SQRT(N_ELEMENTS(denominator))
        indexdiff = ABS(index - (nummean/(denmean + sigmadenmean)))
        IF indexdiff LT 0. THEN PRINT, 'HUH'
    ENDIF
ENDIF

;now return whicheverone job tells us the user wants
IF job EQ 0 THEN RETURN, index ELSE RETURN, indexdiff

END
