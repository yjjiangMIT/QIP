pvc = exp(1i*(PC0C+PC1C*ncn.cfreq/(ncn.cfreq(end)-ncn.cfreq(1)))*pi/180);
ncnCorrected = ncn;
ncnCorrected.cspect = ncn.cspect.*pvc;
figure;
plot(ncnCorrected.cfreq, imag(ncnCorrected.cspect));