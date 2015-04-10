% Does phase corrections for hydrogen, then redo peak integrals.
% Absolute values are taken. Then the sign is added.

% Phase corrections
pvh = exp(1i*(PC0H+PC1H*spectTemp.hfreq/(spectTemp.hfreq(end)-spectTemp.hfreq(1)))*pi/180);
spectTemp.hspect = pvh.*spectTemp.hspect;
spectTemp.hspect = abs(spectTemp.hspect) .* abs(real(spectTemp.hspect)) ./ real(spectTemp.hspect);

% Redo peak integrals
pf = evalin('base', 'calib.pf');
iw = evalin('base', 'calib.iwidth');

hpeak = do_integral(spectTemp.hfreq, spectTemp.hspect, pf, iw, spectTemp.hsfo);
spectTemp.hpeaks = hpeak(1:2);