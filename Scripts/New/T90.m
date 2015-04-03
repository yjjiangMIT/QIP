workspaceDir = 'C:\Users\Yijun\Desktop\QIP\03312015\Data\Workspace';
phaseFileName = 'phase_03312015';
calibName = 'calib_03312015';
calib = loadCalib(workspaceDir, calibName);

folderDirRD = 'C:\Users\Yijun\Desktop\QIP\03312015\Data\RawData\T90_03312015';
files = getFileNames(folderDirRD);

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
    spect = phaseCorrection(workspaceDir, phaseFileName, spect, calib);
    
    % Find peaks
    peaks = [peaks; spect.hpeaks, spect.cpeaks];
end

figure;
plot(pwtab, real(peaks(:,1)));
title('Hydrogen');
figure;
plot(pwtab, real(peaks(:,3)));
title('Carbon');