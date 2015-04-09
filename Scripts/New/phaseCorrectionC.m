function [ spectNew ] = phaseCorrectionC( folderDir, phaseFileName, spect )
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
pvc = exp(1i*(PC0C+PC1C*spect.cfreq/(spect.cfreq(end)-spect.cfreq(1)))*pi/180);
spectNew.cspect = pvc.*spect.cspect;

% Redo peak integrals
pf = evalin('base','calib.pf');
iw = evalin('base','calib.iwidth');

cpeak = doIntegral(spectNew.cfreq, spectNew.cspect, pf, iw, spectNew.csfo);
spectNew.cpeaks = cpeak(3:4);