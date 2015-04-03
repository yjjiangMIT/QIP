firstRunMe;
workspaceDir = 'C:\Users\Yijun\Desktop\QIP\Data\Workspace';
phaseFileName = 'phase_03312015';
calibName = 'calib_03312015';
calib = importdata([workspaceDir, '\', calibName, '.mat']);

rawDataDir = 'C:\Users\Yijun\Desktop\QIP\Data\Raw data\T90_03312015';
files = getFileNames(rawDataDir);

peaks = [];
pwtab = linspace(1,15,100);

for pw = pwtab
    i = find(pwtab==pw);
    
    % Get data from machine
    % sd = NMRCalib(pw,[0,0]);
    % close(figure(gcf));
    
    % Read data from folder
    load(cell2mat(files(i)), 'spect');
    
    % Phase correction
    spect = phaseCorrection(workspaceDir, phaseFileName, spect);
    
    % Find peaks
    peaks = [peaks; spect.hpeaks, spect.cpeaks];
end

peakH = (real(peaks(:,1))+real(peaks(:,2)))/2;
peakC = (real(peaks(:,3))+real(peaks(:,4)))/2;

peakHFit = peakH(25:65);
timeHFit = pwtab(25:65)';
peakCFit = peakC(40:80);
timeCFit = pwtab(40:80)';

coeffH = polyfit(timeHFit, peakHFit, 2);
coeffC = polyfit(timeCFit, peakCFit, 2);
T90H = -coeffH(2)/2/coeffH(1);
T90C = -coeffC(2)/2/coeffC(1);

figure;
plot(pwtab, peakH);
title('Hydrogen');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');
figure;
plot(pwtab, peakC);
title('Carbon');
xlabel('Time T_{90} [\mus]');
ylabel('Intensity [arb. units]');