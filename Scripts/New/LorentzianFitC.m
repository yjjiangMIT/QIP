% spectFileName = 'time933_0407';
% load(['CalibData\', spectFileName, '.mat']);

phaseFileName = 'phase0407';
load(['PhaseData\', phaseFileName, '.mat']);
load('calibStruct.mat');
plotFlag = 1; % 1 means to plot, 0 means not to plot.

spectTemp = spect;
PhaseCorrectionC;
spectCorrC = spectTemp;

Freq = spectCorrC.cfreq;
Spect = real(spectCorrC.cspect);

Peak1 = 577 : 597;
Peak2 = 1455 : 1475;

fx = @(b,x) b(1)./((x-b(2)).^2+b(3)^2)+b(4);

if(plotFlag)
    figure;
    hold on;
    plot(Freq, Spect);
end

% ---------- First peak ------------
b = [2e6, -107, 1.5, 0];
deltaB = b;
iteration = 0;
x = Freq(Peak1);
y = Spect(Peak1);
while norm(deltaB) > 1e-10 && iteration < 100
    b0 = b;
    b = lsqcurvefit(fx, b, x, y);
    b = nlinfit(x, y, fx, b);
    deltaB = b - b0;
    iteration = iteration + 1;
end
bC1 = b;
FreqCont1 = Freq(Peak1(1)) : 0.001 : Freq(Peak1(end));
SpectCont1 = fx(bC1, FreqCont1);
if(plotFlag)
    plot(FreqCont1, SpectCont1, 'r');
end

% ---------- Second peak -----------
b = [2e6, 108, 1.5, 0];
deltaB = b;
iteration = 0;
x = Freq(Peak2);
y = Spect(Peak2);
while norm(deltaB) > 1e-10 && iteration < 100
    b0 = b;
    b = lsqcurvefit(fx, b, x, y);
    b = nlinfit(x, y, fx, b);
    deltaB = b - b0;
    iteration = iteration + 1;
end
bC2 = b;
FreqCont2 = Freq(Peak2(1)) : 0.001 : Freq(Peak2(end));
SpectCont2 = fx(bC2, FreqCont2);
if(plotFlag)
    plot(FreqCont2, SpectCont2, 'r');
end

% ----------------------------------
spectCorrC.cheight = [bC1(1) bC2(1)];
spectCorrC.ccenter = [bC1(2) bC2(2)];
spectCorrC.cwidth = [bC1(3) bC2(3)];
spectCorrC.coffset = [bC1(4) bC2(4)];