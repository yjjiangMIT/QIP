% Does phase corrections for carbon, then redo peak integrals.
% Absolute values are taken. Then the signs are added.

% Phase corrections
pvc = exp(1i*(PC0C+PC1C*spectTemp.cfreq/(spectTemp.cfreq(end)-spectTemp.cfreq(1)))*pi/180);
spectTemp.cspect = pvc.*spectTemp.cspect;
spectTemp.cspect = abs(spectTemp.cspect) .* abs(real(spectTemp.cspect)) ./ real(spectTemp.cspect);

% Redo peak integrals
pf = evalin('base', 'calib.pf');
iw = evalin('base', 'calib.iwidth');

cpeak = do_integral(spectTemp.cfreq, spectTemp.cspect, pf, iw, spectTemp.csfo);
spectTemp.cpeaks = cpeak(3:4);