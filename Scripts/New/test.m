spectTemp = spect;
PhaseCorrectionH;
PhaseCorrectionC;
spectCorr = spectTemp;
figure;
plot(spectCorr.cfreq, imag(spectCorr.cspect));