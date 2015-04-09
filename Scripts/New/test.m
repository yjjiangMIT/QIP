spect = cn;
pvh = exp(1i*(PC0H+PC1H*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);
spectCorrected = spect;
spectCorrected.hspect = spect.hspect.*pvh;
figure;
plot(spectCorrected.hfreq, real(spectCorrected.hspect));