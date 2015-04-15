dtab = linspace(1000, 25000, 25);
pulses = [0 0; 2 1];
phases = [0 0; 0 0];
nucflag = 2;

for delay = dtab
    sd = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, [delay 0], 0, nucflag);   
    fileName = ['T1_Delay', num2str(delay), 'ReadoutC', date, '.mat'];
    eval(['save ', fileName, ' sd']);
end