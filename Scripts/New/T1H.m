% load('/afs/athena.mit.edu/user/k/a/kakkarav/Desktop/QIP/03312015/Data_03312015/RawData_03312015/Workspace_03312015.mat');
peaks = [];
pwtab = linspace(1000, 25000, 25);

dtab = linspace(1000, 25000, 25);
pulses = [2 1; 0 0];
phases = [0 0; 0 0];
nucflag = 1;

for delay = dtab
    sd = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, [delay 0], 0, nucflag);
    
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
    fileName = ['T1_Delay', num2str(delay), 'ReadoutH', date, '.mat'];
    eval(['save ', fileName, ' sd']);
    % peaks = [peaks ; sd.hpeaks sd.cpeaks];
end
% 
% figure;
% plot(pwtab, real(peaks(:,1)));
% title('Hydrogen');
% figure;
% plot(pwtab, real(peaks(:,3)));
% title('Carbon');