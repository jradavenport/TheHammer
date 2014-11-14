FUNCTION measuregoodlines,lambda,flux,specname,job

;this function takes in a spectra with lambda and flux arrays and
;returns an array containing the EqW of a number of lines useful for
;spectral typing stars.

;!P.MULTI = [0,1,1]

;figure out size of spectra to ensure the line being measured is
;contained within it...
n_spec = N_ELEMENTS(lambda)
firstlambda = lambda[0]
lastlambda = lambda[n_spec-1]

measuredlines = FLTARR(30)

;measure Ca K
;CaKcenter = 3933.7 && CaKwidth = 30.
;measuredlines[0] = EQUIVWIDTH(lambda,flux,CaKcenter,CaKwidth,0,specname+' Ca K', 'Ca K')
;wait = GET_KBRD(1)

;measure Ca K bandhead strength
measuredlines[0] = CALCSPECINDEXNONOISE(lambda, flux, 3923.7, 3943.7, 3943.7, 3953.7,job)

;measure Hdel
;Hdelcenter = 4101.7 && Hdelwidth = 40.
;measuredlines[1] = EQUIVWIDTH(lambda,flux,Hdelcenter,Hdelwidth,0,specname+' H del', 'H del')
;wait = GET_KBRD(1)

;measure Hdel bandhead strength
measuredlines[1] = CALCSPECINDEXNONOISE(lambda, flux, 4086.7, 4116.7, 4136.7, 4176.7,job)

;measure Ca I
;CaI4227center = 4226.7 && CaI4227width = 15.
;measuredlines[2] = EQUIVWIDTH(lambda,flux,CaI4227center,CaI4227width,0,specname+' CaI 4227', 'CaI')
;wait = GET_KBRD(1)

;measure Ca I bandhead strength
measuredlines[2] = CALCSPECINDEXNONOISE(lambda, flux, 4216.7, 4236.7, 4236.7, 4256.7,job)

;measure Gband
;Gbandcenter = 4300. && Gbandwidth = 30.
;measuredlines[3] = EQUIVWIDTH(lambda,flux,Gbandcenter,Gbandwidth,0,specname+' G band', 'G band')
;wait = GET_KBRD(1)

;measure Gband bandhead strength
measuredlines[3] = CALCSPECINDEXNONOISE(lambda, flux, 4285.0, 4315.0, 4260.0, 4285.0,job)

;measure Hgam
;Hgamcenter = 4340.5 && Hgamwidth = 25.
;measuredlines[4] = EQUIVWIDTH(lambda,flux,Hgamcenter,Hgamwidth,0,specname+' H gam', 'H gam')
;wait = GET_KBRD(1)

;measure Hgam bandhead strength
measuredlines[4] = CALCSPECINDEXNONOISE(lambda, flux, 4332.5, 4347.5, 4355.0, 4370.0,job)

;measure FeI
;FeI4383center = 4383.6 && FeI4383width = 10.
;measuredlines[5] = EQUIVWIDTH(lambda,flux,FeI4383center,FeI4383width,0,specname+' FeI 4383', 'FeI 4383')
;wait = GET_KBRD(1)

measuredlines[5] = CALCSPECINDEXNONOISE(lambda, flux, 4378.6, 4388.6, 4355.0, 4370.0,job)

;measure FeI
;FeI4404center = 4404.8 && FeI4404width = 10.
;measuredlines[6] = EQUIVWIDTH(lambda,flux,FeI4404center,FeI4404width,0,specname+' FeI 4404', 'FeI 4404')
;wait = GET_KBRD(1)

measuredlines[6] = CALCSPECINDEXNONOISE(lambda, flux, 4399.8, 4409.8, 4414.8, 4424.8,job)

;measure a bluish color
measuredlines[7] = CALCSPECINDEXNONOISE(lambda, flux, 6100.0, 6300.0, 4500.0, 4700.0,job)

;measure Hbeta
;Hbetacenter = 4862. && Hbetawidth = 30.
;measuredlines[7] = EQUIVWIDTH(lambda,flux,Hbetacenter,Hbetawidth,0,specname+' Hbeta', 'Hbeta')
;wait = GET_KBRD(1)

measuredlines[8] = CALCSPECINDEXNONOISE(lambda, flux, 4847.0, 4877.0, 4817.0, 4847.0,job)

;measure MgI
;MgI5172center = 5172.7 && MgI5172width = 50.
;measuredlines[8] = EQUIVWIDTH(lambda,flux,MgI5172center,MgI5172width,0,specname+' MgI 5172', 'MgI 5172')
;wait = GET_KBRD(1)

measuredlines[9] = CALCSPECINDEXNONOISE(lambda, flux, 5152.7, 5192.7, 5100.0, 5150.0,job)

;measure sodium line
;NaDcenter = 5893. && NaDwidth = 25.
;measuredlines[9] = EQUIVWIDTH(lambda,flux,NaDcenter,NaDwidth,0,specname+' NaI 5893', 'NaI')
;wait = GET_KBRD(1)

measuredlines[10] = CALCSPECINDEXNONOISE(lambda, flux, 5880.0, 5905.0, 5910., 5935.0,job)

;measure CaI line
;CaI6162center = 6162. && CaI6162width = 25.
;measuredlines[10] = EQUIVWIDTH(lambda,flux,CaI6162center,CaI6162width,0,specname+' CaI 6162', 'CaI')
;wait = GET_KBRD(1)

measuredlines[11] = CALCSPECINDEXNONOISE(lambda, flux, 6150.0, 6175.0, 6120.0, 6145.0,job)

;measure baII FeI CaI line blend
;blend6497center = 6497. && blend6497width = 20.
;measuredlines[11] = EQUIVWIDTH(lambda,flux,blend6497center,blend6497width,0,specname+' blend @ 6497 measurement', '6497 Blend')
;wait = GET_KBRD(1)

;measure Halpha
;Hacenter = 6563. && Hawidth = 30.
;measuredlines[12] = EQUIVWIDTH(lambda,flux,Hacenter,Hawidth,0,specname+' Halpha', 'Halpha')
;wait = GET_KBRD(1)

measuredlines[12] = CALCSPECINDEXNONOISE(lambda, flux, 6548.0, 6578.0, 6583.0, 6613.0,job)

;measure CaH3 bandhead strength
measuredlines[13] = CALCSPECINDEXNONOISE(lambda, flux, 6960.0, 6990.0, 7042.0, 7046.0,job)

;measure TiO5 strength
measuredlines[14] = CALCSPECINDEXNONOISE(lambda, flux, 7126.0, 7135.0, 7042.0, 7046.0,job)

;measure VO7434
measuredlines[15] = CALCSPECINDEXNONOISE(lambda, flux, 7430.0, 7470.0, 7550.0, 7570.0,job)

;measure VO7445
measuredlines[16] = CALCSPECINDEXMULTNUMNONOISE(lambda, flux, 7350.0, 7400.0, 0.5625, 7510.0, 7560.0, 0.4375, 7420.0, 7470.0,job)

;measure VO-B
measuredlines[17] = CALCSPECINDEXMULTNUMNONOISE(lambda, flux, 7860.0, 7880.0, 0.5, 8080.0, 8100.0, 0.5, 7960.0, 8000.0,job)

;measure VO7912 
measuredlines[18] = CALCSPECINDEXNONOISE(lambda, flux, 7900.0, 7980.0, 8100.0, 8150.0,job)

;measure Rb-B
measuredlines[19] = CALCSPECINDEXMULTNUMNONOISE(lambda, flux, 7922.6, 7932.6, 0.5, 7962.6, 7972.6, 0.5, 7942.6, 7952.6,job)

;measure NaI lines
;NaI8189center = 8189. && NaI8189width = 25.
;measuredlines[20] = EQUIVWIDTH(lambda,flux,NaI8189center,NaI8189width,0,specname+' FeI 8189', 'FeI')
;wait = GET_KBRD(1)

measuredlines[20] = CALCSPECINDEXNONOISE(lambda, flux, 8177.0, 8201.0, 8151.0, 8175.0,job)

;measure NaI 8189 lines with a different method
;measuredlines[21] = CALCSPECINDEXNONOISE(lambda, flux, 8140.0, 8165.0, 8173.0, 8210.0,job)

;measure TiOB
measuredlines[21] = CALCSPECINDEXNONOISE(lambda, flux, 8400.0, 8415.0, 8455.0, 8470.0,job)

;measure TiO8440
measuredlines[22] = CALCSPECINDEXNONOISE(lambda, flux, 8440.0, 8470.0, 8400.0, 8420.0,job)

;measure Cs-A
measuredlines[23] = CALCSPECINDEXMULTNUMNONOISE(lambda, flux, 8496.1, 8506.1, 0.5, 8536.1, 8546.1, 0.5, 8516.1, 8526.1,job)

;measure CaII lines
;CaII8498center = 8498. && CaII8498width = 30.
;measuredlines[25] = EQUIVWIDTH(lambda,flux,CaII8498center,CaII8498width,0,specname+' CaII 8498', 'CaII')
;wait = GET_KBRD(1)

measuredlines[24] = CALCSPECINDEXNONOISE(lambda, flux, 8483.0, 8513.0, 8513.0, 8543.0,job)

;measure CrH-A
measuredlines[25] = CALCSPECINDEXNONOISE(lambda, flux, 8580.0, 8600.0, 8621.0, 8641.0,job)

;CaII8662center = 8662. && CaII8662width = 25.
;measuredlines[26] = EQUIVWIDTH(lambda,flux,CaII8662center,CaII8662width,0,specname+' CaII 8662', 'CaII')
;wait = GET_KBRD(1)

measuredlines[26] = CALCSPECINDEXNONOISE(lambda, flux, 8650.0, 8675.0, 8625.0, 8650.0,job)

;measure FeI 8689
;FeI8689center = 8689. && FeI8689width = 10.
;measuredlines[28] = EQUIVWIDTH(lambda,flux,FeI8689center,FeI8689width,0,specname+' FeI 8689', 'FeI')
;wait = GET_KBRD(1)

measuredlines[27] = CALCSPECINDEXNONOISE(lambda, flux, 8684.0, 8694.0, 8664.0, 8674.0,job)

;measure color-1
measuredlines[28] = CALCSPECINDEXNONOISE(lambda, flux, 8900.0, 9100.0, 7350.0, 7550.0,job)

;measure another color
measuredlines[29] = CALCSPECINDEXNONOISE(lambda, flux, 7350.0, 7550.0, 6100.0, 6300.0,job)

RETURN, measuredlines

END
