% spectFileName = 'time754_0407';
% load(['CalibData\', spectFileName, '.mat']);

phaseFileName = 'phase0407';
load(['PhaseData\', phaseFileName, '.mat']);
load('calibStruct.mat');
plotFlag = 0; % 1 means to plot, 0 means not to plot.

spectTemp = spect;
PhaseCorrectionH;
spectCorrH = spectTemp;

Freq = spectCorrH.hfreq;
Spect = real(spectCorrH.hspect);

Peak1 = 577 : 597;
Peak2 = 1455 : 1475;

fx = @(b,x) b(1)./((x-b(2)).^2+b(3)^2)+b(4);

if(plotFlag)
    figure;
    hold on;
    plot(Freq, Spect);
end

% ---------- First peak ------------
b = [2e7, -107, 1.5, 0];
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
bH1 = b;
FreqCont1 = Freq(Peak1(1)) : 0.001 : Freq(Peak1(end));
SpectCont1 = fx(bH1, FreqCont1);
if(plotFlag)
    plot(FreqCont1, SpectCont1, 'r');
end

% ---------- Second peak -----------
b = [2e7, 108, 1.5, 0];
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
bH2 = b;
FreqCont2 = Freq(Peak2(1)) : 0.001 : Freq(Peak2(end));
SpectCont2 = fx(bH2, FreqCont2);
if(plotFlag)
    plot(FreqCont2, SpectCont2, 'r');
end

% ----------------------------------
spectCorrH.hheight = [bH1(1) bH2(1)];
spectCorrH.hcenter = [bH1(2) bH2(2)];
spectCorrH.hwidth = [bH1(3) bH2(3)];
spectCorrH.hoffset = [bH1(4) bH2(4)];