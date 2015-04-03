load('/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/03312015/Data_03312015/RawData_03312015/Workspace_03312015.mat');
peaks = [];
pwtab = linspace(1,8000,5);

dtab = linspace(1,8000,5);
pulses=[0 0;2 1]
phases=[0 0;0 0]
nucflag = 0

for delay = dtab
    sd = NMRRunPulseProg([7.5051 9.3434],[0 0],pulses,phases,[delay 0],0,nucflag);
    
%     pvh = exp(1i*(PC0H+PC1H*sd.hfreq/(sd.hfreq(end)-sd.hfreq(1)))*pi/180);
%     pvc = exp(1i*(PC0C+PC1C*sd.cfreq/(sd.cfreq(end)-sd.cfreq(1)))*pi/180);
%     sd.hspect = sd.hspect.*pvh;
%     sd.cspect = sd.cspect.*pvc;
%     
%     pf = evalin('base','calib.pf');
%     iw = evalin('base','calib.iwidth');
%     hpeak = do_integral(sd.hfreq, sd.hspect, pf, iw, sd.hsfo);
%     sd.hpeaks = hpeak(1:2);
% 
%     cpeak = do_integral(sd.cfreq, sd.cspect, pf, iw, sd.csfo);
%     sd.cpeaks = cpeak(3:4);
%     
    peaks = [peaks ; sd.hpeaks sd.cpeaks];
end
% 
% figure;
% plot(pwtab, real(peaks(:,1)));
% title('Hydrogen');
% figure;
% plot(pwtab, real(peaks(:,3)));
% title('Carbon');
