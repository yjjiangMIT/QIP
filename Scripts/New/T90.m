% phaseFileName = 'phase0409';
% addpath('/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/Scripts/New/T90RawData0409')
% rawDataDir = '/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/Scripts/New/T90RawData0409';

rawDataDir = 'T90RawData0410';
files = getFileNames(rawDataDir);
number = length(files);

peaks = [];
pwtab = 1:50;

for i = 1 : number
    
    % Read data from folder
    load(cell2mat([rawDataDir, '/', files(i)])); % Ubuntu
    % load(cell2mat([rawDataDir, '\', files(i)])); % Windows

    % ---------- 1st way: use peak integrals ----------
    % Phase correction
    spectTemp = spect;
    PhaseCorrectionC;
    PhaseCorrectionH;
    spectCorr = spectTemp;
    clear spectTemp;
    
    % Find peaks
    peaks = [peaks; spectCorr.hpeaks, spectCorr.cpeaks];

    % ---------- 2nd way: use peak heights ----------
%     LorentzianFitH; % Comment out the first two lines in this function!
%     close(figure(gcf));
%     LorentzianFitC; % Comment out the first two lines in this function!
%     close(figure(gcf));
%     peaks = [peaks; spectCorrH.hheight, spectCorrC.cheight];
    
end

peakH = (real(peaks(:,1))+real(peaks(:,2)))/2;
peakC = (real(peaks(:,3))+real(peaks(:,4)))/2;

peakH1 = real(peaks(:,1));
peakH2 = real(peaks(:,2));
peakC1 = real(peaks(:,3));
peakC2 = real(peaks(:,4));

peakHFit = peakH;
timeHFit = pwtab';
peakCFit = peakC;
timeCFit = pwtab';

%Parabola
coeffH = polyfit(timeHFit, peakHFit, 2);
coeffC = polyfit(timeCFit, peakCFit, 2);
T90H = -coeffH(2)/2/coeffH(1);
T90C = -coeffC(2)/2/coeffC(1);

pwtabCont = 1:0.01:50;

figure;
hold on;
plot(pwtab, peakH);
plot(pwtabCont, polyval(coeffH, pwtabCont), 'r');
title('Hydrogen');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');

figure;
hold on;
plot(pwtab, peakC);
plot(pwtabCont, polyval(coeffC, pwtabCont), 'r');
title('Carbon');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');