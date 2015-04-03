function plotRephasedPeaks( spect )
% plotRephasedPeaks( spect )
% Plot rephased peaks of hydrogen and carbon

global calib;
workspaceDir = 'C:\Users\Yijun\Desktop\QIP\Data\Workspace';
phaseFileName = 'phase_03312015';
calibName = 'calib_03312015';
calib = importdata([workspaceDir, '\', calibName, '.mat']);

spect = phaseCorrection(workspaceDir, phaseFileName, spect);
plotUnrephasedPeaks(spect);