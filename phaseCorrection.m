function phaseCorrection( folderDir, phaseFileName, spect,calib)
% phaseCorrection( folderDir, phaseFileName, spect )
% Do phase corrections for hydrogen and carbon, then redo peak integrals
% phaseFileName does not need an extension .mat

load([folderDir, '/', phaseFileName, '.mat']);  % Load workspace containing phase correction parameters: PC0H, PC1H, PC0C, PC1C

% Phase corrections
pvh = exp(1i*(PC0H+PC1H*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);
spect.hspect = pvh.*spect.hspect;

pvc = exp(1i*(PC0C+PC1C*spect.cfreq/(spect.cfreq(end)-spect.cfreq(1)))*pi/180);
spect.cspect = pvc.*spect.hspect;

% Redo peak integrals
pf = evalin('base','calib.pf');
iw = evalin('base','calib.iwidth');

hpeak = do_integral(spect.hfreq, spect.hspect, pf, iw, spect.hsfo);
spect.hpeaks = hpeak(1:2);

cpeak = do_integral(spect.cfreq, spect.cspect, pf, iw, spect.csfo);
spect.cpeaks = cpeak(3:4);