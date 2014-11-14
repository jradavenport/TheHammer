FUNCTION scaler, lambda1, flux1, lambda2, flux2

;this function returns the constants by which you need to divide two
;spectra to obtain a mean value of 1 over the range in which the two 
;spectra overlap

low1 = MIN( lambda1 )			;find lowest lambda in lambda1 
low2 = MIN( lambda2 )			;find lowest lambda in lambda2
high1 = MAX( lambda1 ) 			;find highest lambda in lambda1
high2 = MAX( lambda2 )			;find highest lambda in lambda2

IF low1 GT low2 THEN overlaplow = low1 ELSE overlaplow = low2 	      ;find highest low boundary
IF high1 LT high2 THEN overlaphigh = high1 ELSE overlaphigh = high2   ;find lowest high boundary

lowestlow = 5000.  &  highesthigh = 8500.

IF overlaplow LT lowestlow THEN overlaplow = lowestlow
IF overlaphigh GT highesthigh THEN overlaphigh = highesthigh

IF overlaplow LT overlaphigh THEN BEGIN                               ;if there is true overlap, go for it

    usable1 = WHERE(lambda1 GE overlaplow AND lambda1 LE overlaphigh)
    mean1 = MEAN(flux1[usable1])

    usable2 = WHERE(lambda2 GE overlaplow AND lambda2 LE overlaphigh)
    mean2 = MEAN(flux2[usable2])

ENDIF ELSE BEGIN
    
    mean1 = 1.  &  mean2 = 1.

ENDELSE

datastructure = [mean1,mean2]
RETURN, datastructure

END

