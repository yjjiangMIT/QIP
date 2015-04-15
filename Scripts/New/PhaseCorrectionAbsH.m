% Does phase corrections for hydrogen, then redo peak integrals.
% Absolute values are taken. Then the sign is added.

% Phase corrections
pvh = exp(1i*(PC0H+PC1H*spectTemp.hfreq/(spectTemp.hfreq(end)-spectTemp.hfreq(1)))*pi/180);
spectTemp.hspect = pvh.*spectTemp.hspect;
for i = 1 : 1024
    spectTemp.hspect(i) = abs(spectTemp.hspect(i)) .* abs(real(spectTemp.hspect(588))) ./ real(spectTemp.hspect(588));
    offset = sum(spectTemp.hspect(1:400)) / 400;
    spectTemp.hspect(i) = spectTemp.hspect(i) - offset;
end
for i = 1025 : 2048
	spectTemp.hspect(i) = abs(spectTemp.hspect(i)) .* abs(real(spectTemp.hspect(1467))) ./ real(spectTemp.hspect(1467));
    offset = sum(spectTemp.hspect(end-399:end)) / 400;
    spectTemp.hspect(i) = spectTemp.hspect(i) - offset;
end 

% Redo peak integrals
pf = evalin('base', 'calib.pf');
iw = evalin('base', 'calib.iwidth');

hpeak = do_integral(spectTemp.hfreq, spectTemp.hspect, pf, iw, spectTemp.hsfo);
spectTemp.hpeaks = hpeak(1:2);