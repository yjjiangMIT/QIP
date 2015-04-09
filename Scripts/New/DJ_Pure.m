J = 215;
qubitSeq = '1C2H';
readoutNuc = 'H';
i = 1;
f= 2;
fileName = ['Seq', qubitSeq, 'Readout', readoutNuc, '0407.mat'];

%U1:Identity
pulses1 = [];
phases1 = [];
delays1 = [];

%U2:Not
pulses2 = [0 ; 2];
phases2 = [0 ; 0];
delays2 = [0 ; 0];

%U3:Cnot
pulses3 = [1 1 1 0 0 0 ;0 0 0 1 1 1 ];
phases3 = [2 1 0 0 0 0 ;0 0 0 0 1 3 ];
delays3 = [0 0 0 0 1/2/J*1000 0 0];

%U4:Not-Cnot
pulses4 = [pulses2, pulses3];
phases4 = [phases2, phases3];
delays4 = [delays2, delays3]

init = {[0; 0], [0 ; 2], [2 ; 0], [2 ; 2]};
read = {[1 ; 0], [0 ; 1]}; %H or C

pulsesi = [0 1; 1 0];
phasesi = [0 1; 3 0];
delaysi = [0 0; 0 0];

pulsesf = [0 1; 1 0];
phasesf = [0 3; 1 0];
delaysf = [0 0; 0 0];

%Deutsch-Jozsa ry2'*ry1*U_f*ry2*ry1'
%  pulses = [pulsesi, ['pulse',num2str(i)], pulsesf];
%  phases = [phasesi, phases1, phasesf];
%  delays = [delaysi, delays1, delaysf];


if(f == 1)
    %for f1
    pulses = [pulsesi, pulse1, pulsesf];
    phases = [phasesi, phases1, phasesf];
    delays = [delaysi, delays1, delaysf];
elseif(f == 2)
    %for f1
    pulses = [pulsesi, pulse2, pulsesf];
    phases = [phasesi, phases2, phasesf];
    delays = [delaysi, delays2, delaysf];
elseif(f == 3)
    %for f1
    pulses = [pulsesi, pulse3, pulsesf];
    phases = [phasesi, phases3, phasesf];
    delays = [delaysi, delays3, delaysf];
elseif(f == 4)
    %for f1
    pulses = [pulsesi, pulse4, pulsesf];
    phases = [phasesi, phases4, phasesf];
    delays = [delaysi, delays4, delaysf];
end

%for reading add read
if (readoutNuc=='H')
    pulses = [pulses, read{1}];
    phases = [phases, [0;0]];
    delays = [delays, [0;0];
    nucflag = 1;
    
elseif (readoutNuc=='C')
    pulses = [pulses, read{2}];
    phases = [phases, [0;0]];
    delays = [delays, [0;0];
    nucflag = 2;
end
    
%Initialize pure states
if(tavgflag == 1)
    pulses = [ini{i},pulses];
    phases = [[0;0],phases];
    delays = [[0,0],delays];
end

cn = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
eval(['save ',fileName,' cn']);





% thermal = NMRCalib(thermalTime, [0,0]);
% 
% % correct phase/ peaks
% cnCorrected = cn;
% thermalCorrected = thermal;
% 
% if(readoutNuc == 'H')
%     pvh = exp(1i*(PC0H+PC1H*cn.hfreq/(cn.hfreq(end)-cn.hfreq(1)))*pi/180);
%     cnCorrected.hspect = cn.hspect.*pvh;
%     pvh = exp(1i*(PC0H+PC1H*thermal.hfreq/(thermal.hfreq(end)-thermal.hfreq(1)))*pi/180);
%     thermalCorrected.hspect = thermal.hspect.*pvh;
%     pf = evalin('base','calib.pf');
%     iw = evalin('base','calib.iwidth');
%     hpeak = do_integral(cnCorrected.hfreq, cnCorrected.hspect, pf, iw, cnCorrected.hsfo);
%     cnCorrected.hpeaks = hpeak(1:2);
%     hpeak = do_integral(thermalCorrected.hfreq, thermalCorrected.hspect, pf, iw, thermalCorrected.hsfo);
%     thermalCorrected.hpeaks = hpeak(1:2);
%     figure;
%     plot(cnCorrected.hfreq, real(cnCorrected.hspect));
%     title('Near CNOT');
%     xlabel('Frequency [Hz]');
%     ylabel('Intensity [arb. units]');
%     figure;
%     plot(thermalCorrected.hfreq, real(thermalCorrected.hspect));
%     title('Thermal');
%     xlabel('Frequency [Hz]');
%     ylabel('Intensity [arb. units]');
%     ratio = [cnCorrected.hpeaks./thermalCorrected.hpeaks];
% elseif(readoutNuc == 'C')
%     pvc = exp(1i*(PC0C+PC1C*cn.cfreq/(cn.cfreq(end)-cn.cfreq(1)))*pi/180);
%     cnCorrected.cspect = cn.cspect.*pvc;
%     pvc = exp(1i*(PC0C+PC1C*thermal.cfreq/(thermal.cfreq(end)-thermal.cfreq(1)))*pi/180);
%     thermalCorrected.cspect = thermal.cspect.*pvc;
%     pf = evalin('base','calib.pf');
%     iw = evalin('base','calib.iwidth');
%     cpeak = do_integral(cnCorrected.cfreq, cnCorrected.cspect, pf, iw, cnCorrected.csfo);
%     cnCorrected.cpeaks = cpeak(3:4);
%     cpeak = do_integral(thermalCorrected.cfreq, thermalCorrected.cspect, pf, iw, thermalCorrected.csfo);
%     thermalCorrected.cpeaks = cpeak(3:4);
%     figure;
%     plot(cnCorrected.cfreq, real(cnCorrected.cspect));
%     title('Near CNOT');
%     xlabel('Frequency [Hz]');
%     ylabel('Intensity [arb. units]');
%     figure;
%     plot(thermalCorrected.cfreq, real(thermalCorrected.cspect));
%     title('Thermal');
%     xlabel('Frequency [Hz]');
%     ylabel('Intensity [arb. units]');
%     ratio = [cnCorrected.cpeaks./thermalCorrected.cpeaks];
% end