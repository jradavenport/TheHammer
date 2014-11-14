FUNCTION readsloanspec,filename         ;this function takes in the name of a sloan
                                        ;spectra fits file and returns a 3 by X array
                                        ;called datastructure, where X is the number
                                        ;of data points measured.  datastructure(0,*)
                                        ;gives the wavelength information in
                                        ;air wavelengths, (1,*) gives
                                        ;flux, and (2,*) gives noise information.

data = READFITS( filename,header,/SILENT )      ;read data into data, header into header
basewave = SXPAR( header,'COEFF0' )     ;find the starting wavelength of the spectrum in weird sloan units
step = SXPAR( header,'COEFF1' )         ;find how big the wavelength step is in weird sloan units
nsteps = SXPAR( header,'NAXIS1' )       ;find the # of pixels in the spectra
wave = 10.0^( basewave + FINDGEN( nsteps ) * step )     ;now create an array for the wavelength values...
VACTOAIR, wave
                                        ;convert the wavelengths to air wavelengths
datastructure = FLTARR(3,nsteps)        ;create a data structure to send back all
                                                ;the info we've gathered.
datastructure[0,*] = wave               ;fill it with wavelength
datastructure[1,*] = REFORM( data[*,0] );flux
datastructure[2,*] = REFORM( data[*,2] );noise
 
RETURN,datastructure           

END
