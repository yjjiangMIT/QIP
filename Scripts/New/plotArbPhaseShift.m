pvh = exp(1i*(-131.3542+170.5102*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);

figure;
plot(spect.hfreq, real(pvh.*spect.hspect));
title('Hydrogen');
xlabel('Frequency [Hz]');
ylabel('Intensity [Arb. units]');

figure;
plot(spect.hfreq, imag(pvh.*spect.hspect));
title('Hydrogen');
xlabel('Frequency [Hz]');
ylabel('Intensity [Arb. units]');