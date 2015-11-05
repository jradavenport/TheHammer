FUNCTION numericaltypes, typearray

;take in an array of floats giving spectral types and return a
;numerical array of spectral types

n_types = N_ELEMENTS(typearray)

possibletypes = ['O0','O1','O2','O3','O4','O5','O6','O7','O8','O9','B0','B1','B2','B3','B4','B5','B6','B7','B8','B9','A0','A1','A2','A3','A4','A5','A6','A7','A8','A9','F0','F1','F2','F3','F4','F5','F6','F7','F8','F9','G0','G1','G2','G3','G4','G5','G6','G7','G8','G9','K0','K1','K2','K3','K4','K5','K7','M0','M1','M2','M3','M4','M5','M6','M7','M8','M9','L0','L1','L2','L3','L4','L5','L6','L7','L8','L9','T0','T1','T2','T3','T4','T5','T6','T7','T8','T9']

;create an array to store numerical types in
numbertypes = INTARR(n_types)

;loop through the possible types and place objects that match the
;possible type with the current numerical type
FOR i=0,78 DO BEGIN

    thistype = WHERE(typearray EQ possibletypes[i])
    IF TOTAL(thistype) NE -1 THEN numbertypes[thistype] = i
    
ENDFOR

RETURN, numbertypes

END
