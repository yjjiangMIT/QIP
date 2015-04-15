phaseFile = 'phase0410.mat';
rawDataDir = '/Users/kampholakkaravarawong/Dropbox (MIT)/QIP (1)/Scripts/New/T90RawData0410';
startWidth = 6;
endWidth = 15;

peakFindingMethod = '1'; % '1' = Peak integrals; '2' = Abs peak integrals; '3' = Peak heights.
whichPeak = '3'; % '1' = First peak; '2' = Second peak; '3' = Average of both peaks.
fitMethod = 'para'; % 'expsin' = Exponentially damping sinusoid, 'para' = Parabola.

% ---------- No need to edit the following for different data sets ----------
files = getFileNames(rawDataDir);
number = length(files);
load('calibStruct.mat');
phaseDir = 'PhaseData';
load([phaseDir, '\', phaseFile]);

peaks = [];
pwtab = linspace(startWidth, endWidth, number);

for i = 1 : number
    
    % Read data from folder
    load(cell2mat([rawDataDir, '/', files(i)])); % Ubuntu
    % load(cell2mat([rawDataDir, '\', files(i)])); % Windows

    if(peakFindingMethod == '1')
        % ---------- 1st way: use peak integrals ----------
        % Phase correction
        spectTemp = spect;
        PhaseCorrectionC;
        PhaseCorrectionH;
        spectCorr = spectTemp;
        clear spectTemp;
        
        % Find peaks
        peaks = [peaks; spectCorr.hpeaks, spectCorr.cpeaks];
    elseif(peakFindingMethod == '2')
        % ---------- 2nd way: taking absolute values and then use peak integrals ----------
        % Phase correction
        spectTemp = spect;
        PhaseCorrectionAbsC;
        PhaseCorrectionAbsH;
        spectCorr = spectTemp;
        clear spectTemp;
        
        % Find peaks
        peaks = [peaks; spectCorr.hpeaks, spectCorr.cpeaks];
    elseif(peakFindingMethod == '3')
        % ---------- 3rd way: use peak heights ----------
        % Only works when the range is small!
        LorentzianFitH; % Comment out the first two lines in this function!
        close(figure(gcf));
        LorentzianFitC; % Comment out the first two lines in this function!
        close(figure(gcf));
        peaks = [peaks; spectCorrH.hheight, spectCorrC.cheight];
    end
end

peakH1 = real(peaks(:,1));
peakH2 = real(peaks(:,2));
peakC1 = real(peaks(:,3));
peakC2 = real(peaks(:,4));

if(whichPeak == '1')
    peakH = peakH1;
    peakC = peakC1;
elseif(whichPeak == '2')
    peakH = peakH2;
    peakC = peakC2;
elseif(whichPeak == '3')
    peakH = (peakH1 + peakH2)/2;
    peakC = (peakC1 + peakC2)/2;
end

peakHFit = peakH;
timeHFit = pwtab';
peakCFit = peakC;
timeCFit = pwtab';

if(strcmp(fitMethod, 'para'))
    % Parabola
    coeffH = polyfit(timeHFit, peakHFit, 2);
    coeffC = polyfit(timeCFit, peakCFit, 2);
    T90H = -coeffH(2)/2/coeffH(1);
    T90C = -coeffC(2)/2/coeffC(1);
    
    timeHCont = timeHFit(1) : 0.01 : timeHFit(end);
    timeCCont = timeCFit(1) : 0.01 : timeCFit(end);
    peakHCont = polyval(coeffH, timeHCont);
    peakCCont = polyval(coeffC, timeCCont);
elseif(strcmp(fitMethod, 'expsin'))
    % Exponentially damping sine
    % fx = @(b,x) b(1) .* exp(-b(2).*x) .* sin(b(3).*x) + b(4);
    fx = @(b,x) b(1) .* exp(-b(2).*x) .* sin(b(3).*x + b(4)) + b(5);
    % ---------- Hydrogen ----------
    % b = [7e5, 0, 0.2, 1e5];
    b = [7e5, 0, 0.2, 0, 1e5];
    deltaB = b;
    iteration = 0;
    x = timeHFit;
    y = peakHFit;
    while norm(deltaB) > 1e-10 && iteration < 100
        b0 = b;
        b = lsqcurvefit(fx, b, x, y);
        b = nlinfit(x, y, fx, b);
        deltaB = b - b0;
        iteration = iteration + 1;
    end
    bH = b;
    timeHCont = x(1) : 0.001 : x(end);
    peakHCont = fx(bH, timeHCont);
    T90H = pi/2/bH(3);
    
    % ---------- Carbon ----------
    % b = [5e4, 0, 0.2, 1.5e4];
    b = [5e4, 0, 0.2, 0, 1.5e4];
    deltaB = b;
    iteration = 0;
    x = timeCFit;
    y = peakCFit;
    while norm(deltaB) > 1e-10 && iteration < 100
        b0 = b;
        b = lsqcurvefit(fx, b, x, y);
        b = nlinfit(x, y, fx, b);
        deltaB = b - b0;
        iteration = iteration + 1;
    end
    bC = b;
    timeCCont = x(1) : 0.001 : x(end);
    peakCCont = fx(bC, timeCCont);
    T90C = pi/2/bC(3);
end

% Plot
figure;
hold on;
plot(timeHFit, peakHFit);
plot(timeHCont, peakHCont, 'r');
title('Hydrogen');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');

figure;
hold on;
plot(timeCFit, peakCFit);
plot(timeCCont, peakCCont, 'r');
title('Carbon');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');

[T90H T90C]
