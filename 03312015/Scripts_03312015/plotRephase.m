figure;
pvh = exp(1i*(PC0H+PC1H*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);
plot(spect.hfreq, real(pvh.*spect.hspect));
figure;
pvc = exp(1i*(PC0C+PC1C*spect.cfreq/(spect.cfreq(end)-spect.cfreq(1)))*pi/180);
plot(spect.cfreq, real(pvc.*spect.cspect));