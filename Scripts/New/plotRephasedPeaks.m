function plotRephasedPeaks( spect )
% plotUnrephasedPeaks( spect )
% Plot unrephased peaks of hydrogen and carbon

workspaceDir = 'C:\Users\Yijun\Desktop\QIP\03312015\Data\Workspace';
phaseFileName = 'phase_03312015';
calibName = 'calib_03312015';
calib = loadCalib(workspaceDir, calibName);

spect = phaseCorrection(workspaceDir, phaseFileName, spect, calib);
plotUnrephasedPeaks(spect);