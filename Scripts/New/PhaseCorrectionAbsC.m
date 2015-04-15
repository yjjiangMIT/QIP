% Does phase corrections for carbon, then redo peak integrals.
% Absolute values are taken. Then the signs are added.

% Phase corrections
pvc = exp(1i*(PC0C+PC1C*spectTemp.cfreq/(spectTemp.cfreq(end)-spectTemp.cfreq(1)))*pi/180);
spectTemp.cspect = pvc.*spectTemp.cspect;
for i = 1 : 1024
    spectTemp.cspect(i) = abs(spectTemp.cspect(i)) .* abs(real(spectTemp.cspect(588))) ./ real(spectTemp.cspect(588));
    offset = sum(spectTemp.cspect(1:400)) / 400;
    spectTemp.cspect(i) = spectTemp.cspect(i) - offset;
end
for i = 1025 : 2048
	spectTemp.cspect(i) = abs(spectTemp.cspect(i)) .* abs(real(spectTemp.cspect(1467))) ./ real(spectTemp.cspect(1467));
    offset = sum(spectTemp.cspect(end-399:end)) / 400;
    spectTemp.cspect(i) = spectTemp.cspect(i) - offset;
end 

% Redo peak integrals
pf = evalin('base', 'calib.pf');
iw = evalin('base', 'calib.iwidth');

cpeak = do_integral(spectTemp.cfreq, spectTemp.cspect, pf, iw, spectTemp.csfo);
spectTemp.cpeaks = cpeak(3:4);