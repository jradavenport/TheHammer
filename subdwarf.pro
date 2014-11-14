FUNCTION subdwarf, wave,flux,err

;measure TiO bands
IF TOTAL(WHERE(wave GT 7131.94 AND wave LT 7136.95)) NE -1 THEN Tio5W = MEAN(flux(WHERE(wave GT 7131.94 AND wave LT 7136.95))) ELSE Tio5W = -9999.

IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN Tio5S = MEAN(flux(WHERE(wave GT 7043.92 AND wave LT 7047.92))) ELSE Tio5S = -9999.

 IF TOTAL(WHERE(wave GT 8442.3192 AND wave LT 8472.3273)) NE -1 THEN Tio8W = MEAN(flux(WHERE(wave GT 8442.3192 AND wave LT 8472.3273))) ELSE Tio8W = -9999.
 IF TOTAL(WHERE(wave GT 8402.3083 AND wave LT 8422.3137)) NE -1 THEN Tio8S = MEAN(flux(WHERE(wave GT 8402.3083 AND wave LT 8422.3137))) ELSE Tio8S = -9999.

;measure CaH bands
IF (TOTAL(WHERE(wave GT 6346.73 AND wave LT 6356.73)) NE -1) AND (TOTAL(WHERE(wave GT 6410 AND wave LT 6420)) NE -1) THEN CaH1S = (MEAN(flux(WHERE(wave GT 6346.73 AND wave LT 6356.73))) + MEAN(flux(WHERE(wave GT 6410 AND wave LT 6420))))/2.0 ELSE CaH1S = -9999.
IF TOTAL(WHERE( wave GT 6381.74 AND wave LT 6391.74)) NE -1 THEN CaH1W = MEAN(flux(WHERE( wave GT 6381.74 AND wave LT 6391.74))) ELSE CaH1W = -9999.
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN CaH2S = MEAN(flux(WHERE(wave GT 7043.92 AND wave LT 7047.92))) ELSE CaH2S = -9999.
IF TOTAL(WHERE(wave GT 6815.86 AND wave LT 6847.87)) NE -1 THEN CaH2W = MEAN(flux(WHERE(wave GT 6815.86 AND wave LT 6847.87))) ELSE CaH2W = -9999.
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN CaH3S = MEAN(flux(WHERE(wave GT 7043.92 AND wave LT 7047.92))) ELSE CaH3S = -9999.
IF TOTAL(WHERE(wave GT 6961.9198 AND wave LT 6991.9278)) NE -1 THEN CaH3W = MEAN(flux(WHERE(wave GT 6961.9198 AND wave LT 6991.9278))) ELSE CaH3W = -9999.

;make TiO test variables
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN tio5_u_test = STDDEV(flux(WHERE(wave GT 7043.92 AND wave LT 7047.92)))/(Tio5s-tio5w) ELSE tio5_u_test = -9999.
IF TOTAL(WHERE(wave GT 7131.94 AND wave LT 7136.95)) NE -1 THEN tio5_l_test = STDDEV(flux(WHERE(wave GT 7131.94 AND wave LT 7136.95)))/(Tio5s-tio5w) ELSE tio5_l_test = -9999.
IF TOTAL(WHERE(wave GT 8442.3192 AND wave LT 8472.3273)) NE -1 THEN  tio8_u_test = STDDEV(flux(WHERE(wave GT 8442.3192 AND wave LT 8472.3273)))/(Tio8s-tio8w) ELSE tio8_u_test = -9999.
 IF TOTAL(WHERE(wave GT 8402.3083 AND wave LT 8422.3137)) NE -1 THEN tio8_l_test = STDDEV(flux(WHERE(wave GT 8402.3083 AND wave LT 8422.3137)))/(Tio8s-tio8w) ELSE tio8_l_test = -9999.

 ;make CaH test variables
IF (TOTAL(WHERE(wave GT 6346.73 AND wave LT 6356.73)) NE -1) AND (TOTAL(WHERE(wave GT 6410 AND wave LT 6420)) NE -1) THEN cah1_u_test = SQRT((STDDEV(flux(WHERE(wave GT 6346.73 AND wave LT 6356.73))))^2.0+(STDDEV(flux(WHERE(wave GT 6410 AND wave LT 6420))))^2.0)/(CaH1s-Cah1w) ELSE cah1_u_test = -9999.
IF TOTAL(WHERE( wave GT 6381.74 AND wave LT 6391.74)) NE -1 THEN cah1_l_test = STDDEV(flux(WHERE( wave GT 6381.74 AND wave LT 6391.74)))/(CaH1s-Cah1w) ELSE cah1_l_test = -9999.
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN cah2_u_test = STDDEV(flux(WHERE(wave GT 7043.92 AND wave LT 7047.92)))/(CaH2s-Cah2w) ELSE cah2_u_test = -9999.
IF TOTAL(WHERE(wave GT 6815.86 AND wave LT 6847.87)) NE -1 THEN cah2_l_test=STDDEV(flux(WHERE(wave GT 6815.86 AND wave LT 6847.87)))/(CaH2s-Cah2w) ELSE cah2_l_test = -9999.
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN cah3_u_test=STDDEV(flux(WHERE(wave GT 7043.92 AND wave LT 7047.92)))/(CaH3s-Cah3w) ELSE cah3_u_test = -9999.
IF TOTAL(WHERE(wave GT 6961.9198 AND wave LT 6991.9278)) NE -1 THEN cah3_l_test= STDDEV(flux(WHERE(wave GT 6961.9198 AND wave LT 6991.9278)))/(CaH3s-Cah3w) ELSE cah3_l_test = -9999.

;make Tio errors
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN Tio5Serr = TOTAL((err(WHERE(wave GT 7043.92 AND wave LT 7047.92)))^2.0)/(N_ELEMENTS(WHERE(wave GT 7043.92 AND wave LT 7047.92)))^2.0 ELSE Tio5Serr = -9999.
IF TOTAL(WHERE(wave GT 7131.94 AND wave LT 7136.95)) NE -1 THEN Tio5Werr = TOTAL((err(WHERE(wave GT 7131.94 AND wave LT 7136.95)))^2.0)/(N_ELEMENTS(WHERE(wave GT 7131.94 AND wave LT 7136.95)))^2.0 ELSE Tio5Werr = -9999.
IF TOTAL(WHERE(wave GT 8442.3192 AND wave LT 8472.3273)) NE -1 THEN Tio8Werr = TOTAL((err(WHERE(wave GT 8442.3192 AND wave LT 8472.3273)))^2.0)/(N_ELEMENTS(WHERE(wave GT 8442.3192 AND wave LT 8472.3273)))^2.0 ELSE Tio8Werr = -9999.
IF TOTAL(WHERE(wave GT 8402.3083 AND wave LT 8422.3137)) NE -1 THEN Tio8Serr = TOTAL((err(WHERE(wave GT 8402.3083 AND wave LT 8422.3137)))^2.0)/(N_ELEMENTS(WHERE(wave GT 8402.3083 AND wave LT 8422.3137)))^2.0 ELSE Tio8Serr = -9999.

;make CaH errors
IF (TOTAL(WHERE(wave GT 6346.73 AND wave LT 6356.73)) NE -1) AND (TOTAL(WHERE(wave GT 6410 AND wave LT 6420)) NE -1) THEN CaH1Serr = (TOTAL((err(WHERE(wave GT 6346.73 AND wave LT 6356.73)))^2.0)+TOTAL((err(WHERE(wave GT 6410 AND wave LT 6420)))^2.0))/((N_ELEMENTS(WHERE(wave GT 6346.73 AND wave LT 6356.73))+N_ELEMENTS(WHERE(wave GT 6410 AND wave LT 6420))))^2.0 ELSE CaH1Serr = -9999.
IF TOTAL(WHERE( wave GT 6381.74 AND wave LT 6391.74)) NE -1 THEN CaH1Werr = TOTAL((err(WHERE(wave GT 6381.74 AND wave LT 6391.74)))^2.0)/(N_ELEMENTS(WHERE(wave GT 6381.74 AND wave LT 6391.74)))^2.0 ELSE CaH1Werr = -9999.
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN CaH2Serr = TOTAL((err(WHERE(wave GT 7043.92 AND wave LT 7047.92)))^2.0)/(N_ELEMENTS(WHERE(wave GT 7043.92 AND wave LT 7047.92)))^2.0 ELSE CaH2Serr = -9999.
IF TOTAL(WHERE(wave GT 6815.86 AND wave LT 6847.87)) NE -1 THEN CaH2Werr = TOTAL((err(WHERE(wave GT 6815.86 AND wave LT 6847.87)))^2.0)/(N_ELEMENTS(WHERE(wave GT 6815.86 AND wave LT 6847.87)))^2.0 ELSE CaH2Werr = -9999.
IF TOTAL(WHERE(wave GT 7043.92 AND wave LT 7047.92)) NE -1 THEN CaH3Serr = TOTAL((err(WHERE(wave GT 7043.92 AND wave LT 7047.92)))^2.0)/(N_ELEMENTS(WHERE(wave GT 7043.92 AND wave LT 7047.92)))^2.0 ELSE CaH3Serr = -9999. 
IF TOTAL(WHERE(wave GT 6961.9198 AND wave LT 6991.9278)) NE -1 THEN CaH3Werr = TOTAL((err(WHERE(wave GT 6961.9198 AND wave LT 6991.9278)))^2.0)/(N_ELEMENTS(WHERE(wave GT 6961.9198 AND wave LT 6991.9278)))^2.0 ELSE CaH3Werr = -9999.

;make other error arrays
Tio5err = SQRT(Tio5Werr/Tio5S^2.0 +(Tio5W^2.0*Tio5Serr)/Tio5S^4.0)
Tio8err = SQRT(Tio8Werr/Tio8S^2.0 +(Tio8W^2.0*Tio8Serr)/Tio8S^4.0)
CaH1err = SQRT(CaH1Werr/CaH1S^2.0 +(CaH1W^2.0*CaH1Serr)/CaH1S^4.0)
CaH2err = SQRT(CaH2Werr/CaH2S^2.0 +(CaH2W^2.0*CaH2Serr)/CaH2S^4.0)
CaH3err = SQRT(CaH3Werr/CaH3S^2.0 +(CaH3W^2.0*CaH3Serr)/CaH3S^4.0)

;make ratios
Tio5 = Tio5W/Tio5S
Tio8 = Tio8W/Tio8S
CaH1 = CaH1W/CaH1S
CaH2 = CaH2W/CaH2S
CaH3 = CaH3W/CaH3S

;replace error terms with -9999. for objects whose error array is
;useless
IF err[0] EQ -9999. THEN BEGIN
    Tio5Serr = -9999.
    Tio5Werr = -9999.
    Tio8Werr = -9999.
    Tio8Serr = -9999.
    CaH1Serr = -9999.
    CaH1Werr = -9999.
    CaH2Serr = -9999.
    CaH2Werr = -9999.
    CaH3Serr = -9999.
    CaH3Werr = -9999.
    Tio5err = -9999.
    Tio8err = -9999.
    CaH1err = -9999.
    CaH2err = -9999.
    CaH3err = -9999.
ENDIF

;create an array with all the index values
indexarr = [Tio5,Tio5err,CaH1,CaH1err,CaH2,CaH2err,CaH3,CaH3err,tio8,tio8err,tio5_u_test,tio5_l_test,cah1_u_test,cah1_l_test,cah2_u_test,cah2_l_test,cah3_u_test,cah3_l_test,tio8_u_test,tio8_l_test]

;return that array to the user
RETURN, indexarr

END
