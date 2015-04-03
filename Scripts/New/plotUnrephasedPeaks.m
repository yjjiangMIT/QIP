function plotUnrephasedPeaks( spect )
% plotUnrephasedPeaks( spect )
% Plot unrephased peaks of hydrogen and carbon

figure;
plot(spect.hfreq, real(spect.hspect));
title('Hydrogen');
xlabel('Frequency [Hz]');
ylabel('Intensity [Arb. units]');

figure;
plot(spect.cfreq, real(spect.cspect));
title('Carbon');
xlabel('Frequency [Hz]');
ylabel('Intensity [Arb. units]');