
split = 215
pulses = [1 1 0;0 0 1];
phases = [0 3 0;0 0 0];
delays = [1/split*1000 0 0];
tavgflag = 0;
nucflag = 1;
ncn = NMRRunPulseProg([7.5051 9.3434],[0 0], pulses, phases, delays, tavgflag,nucflag);
thermal = NMRCalib(5,[0,0]);

%correct phase/ peaks

% pvh = exp(1i*(PC0H+PC1H*ncn.hfreq/(ncn.hfreq(end)-ncn.hfreq(1)))*pi/180);
% ncn.hspect = ncn.hspect.*pvh;
% pvh = exp(1i*(PC0H+PC1H*thermal.hfreq/(thermal.hfreq(end)-thermal.hfreq(1)))*pi/180);
% thermal.hspect = thermal.hspect.*pvh;
% pf = evalin('base','calib.pf');
% iw = evalin('base','calib.iwidth');
% hpeak = do_integral(ncn.hfreq, ncn.hspect, pf, iw, ncn.hsfo);
% ncn.hpeaks = hpeak(1:2);
% hpeak = do_integral(thermal.hfreq, thermal.hspect, pf, iw, thermal.hsfo);
% thermal.hpeaks = hpeak(1:2);


pvc = exp(1i*(PC0C+PC1C*ncn.cfreq/(ncn.cfreq(end)-ncn.cfreq(1)))*pi/180);
ncn.cspect = ncn.cspect.*pvc;
pvc = exp(1i*(PC0C+PC1C*ncn.cfreq/(thermal.cfreq(end)-thermal.cfreq(1)))*pi/180);
thermal.cspect = thermal.cspect.*pvc;
pf = evalin('base','calib.pf');
iw = evalin('base','calib.iwidth');
cpeak = do_integral(ncn.cfreq, ncn.cspect, pf, iw, ncn.csfo);
ncn.cpeaks = cpeak(3:4);
cpeak = do_integral(thermal.cfreq, thermal.cspect, pf, iw, thermal.csfo);
thermal.cpeaks = cpeak(3:4);
    
    

% ratio = [ncn.hpeaks./thermal.hpeaks ncn.cpeaks./thermal.cpeaks]
ratio = [ncn.cpeaks./thermal.cpeaks]