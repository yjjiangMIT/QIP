function plotFourierPeaks( spect )
% plotFourierPeaks( spect )
% Plot Fourier peaks of hydrogen and carbon

figure;
plot(spect.hfreq, real(spect.hspect));
title('Hydrogen');
xlabel('Frequency [Hz]');
ylabel('Intensity [Arb. units]');

figure;
plot(spect.cfreq, real(spect.cspect));
title('Hydrogen');
xlabel('Frequency [Hz]');
ylabel('Intensity [Arb. units]');