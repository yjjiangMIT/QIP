firstRunMe;
workspaceDir = 'C:\Users\Yijun\Dropbox (MIT)\Spring 2015 Courses\Jlab\Jlab Data\QIP\Data\Workspace';
phaseFileName = 'phase_04032015';
calibName = 'calib_04032015';
calib = importdata([workspaceDir, '\', calibName, '.mat']);

rawDataDir = 'C:\Users\Yijun\Dropbox (MIT)\Spring 2015 Courses\Jlab\Jlab Data\QIP\Data\Raw data\T90_04032015';
files = getFileNames(rawDataDir);
number = length(files);

peaks = [];
pwtab = linspace(1,15,number);

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


figure;
plot(pwtab, peakH);
title('Hydrogen');
xlabel('Time T_{90} [\mus]');

% peakHFit = peakH(25:65);
% timeHFit = pwtab(25:65)';
% peakCFit = peakC(40:80);
% timeCFit = pwtab(40:80)';

peakHFit = peakH(4:11);
timeHFit = pwtab(4:11)';
peakCFit = peakC(5:13);
timeCFit = pwtab(5:13)';

coeffH = polyfit(timeHFit, peakHFit, 2);
coeffC = polyfit(timeCFit, peakCFit, 2);
T90H = -coeffH(2)/2/coeffH(1);
T90C = -coeffC(2)/2/coeffC(1);

ylabel('Intensity [arb. units]');
figure;
plot(pwtab, peakC);
title('Carbon');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');