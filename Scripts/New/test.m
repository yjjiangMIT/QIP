pvh = exp(1i*(PC0H+PC1H*thermal.hfreq/(thermal.hfreq(end)-thermal.hfreq(1)))*pi/180);
thermalCorrected = thermal;
thermalCorrected.hspect = thermal.hspect.*pvh;
figure;
plot(thermalCorrected.hfreq, real(thermalCorrected.hspect));