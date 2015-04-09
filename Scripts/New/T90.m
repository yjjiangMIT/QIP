firstRunMe;
workspaceDir = '/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/Scripts/New';
phaseFileName = 'phase0409';
% calibName = 'calib_04032015';
% calib = importdata([workspaceDir, '\', calibName, '.mat']);
addpath('/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/Scripts/New/PulseWidth0409')
rawDataDir = '/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/Scripts/New/PulseWidth0409';
files = getFileNames(rawDataDir);
number = length(files);

peaks = [];
pwtab = linspace(6,12,10);

for pw = pwtab
    i = find(pwtab==pw);
    
    % Read data from folder
    load(cell2mat(files(i)), 'spect');
    
    % Phase correction
    spect = phaseCorrection(workspaceDir, phaseFileName, spect);
    
    % Find peaks
    peaks = [peaks; spect.hpeaks, spect.cpeaks];
end

peakH = (real(peaks(:,1))+real(peaks(:,2)))/2;
peakC = (real(peaks(:,3))+real(peaks(:,4)))/2;
% peakC = (real(peaks(:,4)));

% peakH = real(peaks(:,2));
% peakC = real(peaks(:,4));

peakH1 = real(peaks(:,1));
peakH2 = real(peaks(:,2));
peakC1 = real(peaks(:,3));
peakC2 = real(peaks(:,4));

% peakHFit = peakH(25:65);
% timeHFit = pwtab(25:65)';
% peakCFit = peakC(40:80);
% timeCFit = pwtab(40:80)';

% peakHFit = peakH(4:11);
% timeHFit = pwtab(4:11)';
% peakCFit = peakC(5:13);
% timeCFit = pwtab(5:13)';

peakHFit = peakH;
timeHFit = pwtab';
peakCFit = peakC;
timeCFit = pwtab';

%Parabola
coeffH = polyfit(timeHFit, peakHFit, 2);
coeffC = polyfit(timeCFit, peakCFit, 2);
T90H = -coeffH(2)/2/coeffH(1);
T90C = -coeffC(2)/2/coeffC(1);

%Quartic model
% coeffH1 = polyfit(timeHFit, peakHFit, 2);
% coeffC2 = polyfit(timeCFit, peakCFit, 2);
% T90H = -coeffH(2)/2/coeffH(1)
% T90C = -coeffC(2)/2/coeffC(1)

pwtabCont = 6 : 0.01 : 12;

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