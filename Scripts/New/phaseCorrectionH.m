function [ spectNew ] = phaseCorrectionH( folderDir, phaseFileName, spect )
% phaseCorrection( folderDir, phaseFileName, spect )
% Do phase corrections for hydrogen and carbon, then redo peak integrals
% phaseFileName does not need an extension .mat

spectNew = spect;
phase = importdata([folderDir, '/', phaseFileName, '.mat']);
global calib PC0H PC1H PC0C PC1C
PC0H = phase.PC0H;
PC1H = phase.PC1H;
PC0C = phase.PC0C;
PC1C = phase.PC1C;

% Phase corrections
pvh = exp(1i*(PC0H+PC1H*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);
spectNew.hspect = pvh.*spect.hspect;

% Redo peak integrals
pf = evalin('base','calib.pf');
iw = evalin('base','calib.iwidth');

hpeak = doIntegral(spectNew.hfreq, spectNew.hspect, pf, iw, spectNew.hsfo);
spectNew.hpeaks = hpeak(1:2);