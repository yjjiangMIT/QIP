% Performs Deutsch-Jotza algorithm.
% Loops over all four functions and two readout nuclei.
% stateIndex: which input state is used.
% functionIndex: which function is used.
% readoutNuc: which qubit is the readout.
% Output structs into files.
% Example file name: f1Pure00ReadoutH0410.mat.

J = 214.94;
tavgflag = 1;
date = '0409';
States = {'00', '01', '10', '11'};
stateIndex = 1;
load(['T90Data/T90Rough_', date, '.mat']);

% Uf1: Identity
pulses1 = [];
phases1 = [];
delays1 = [];

% Uf2: NOT(y), y is the first qubit
pulses2 = [0; 2];
phases2 = [0; 0];
delays2 = 0;

% Uf3: CNOT(x,y), use x (the second qubit) to control y (the first qubit)
% ry1'*tau*ry1*rx1*rx2*ry2*rx2'
pulses3 = [1 1 1 0 0 0; 0 0 0 1 1 1];
phases3 = [2 1 0 0 0 0; 0 0 0 0 1 3];
delays3 = [0 0 0 0 1/2/J*1000 0];

% Uf4: NOT(y)-CNOT(x,y)
pulses4 = [pulses2, pulses3];
phases4 = [phases2, phases3];
delays4 = [delays2, delays3];

init = {[0; 0], [0; 2], [2; 0], [2; 2]};
read = {[1; 0], [0; 1]}; % H or C

pulsesi = [0 1; 1 0];
phasesi = [0 1; 3 0];
delaysi = [0 0];

pulsesf = [0 1; 1 0];
phasesf = [0 3; 1 0];
delaysf = [0 0];

% Deutsch-Jozsa ry2'*ry1*U_f*ry2*ry1'
% pulses = [pulsesi, ['pulse',num2str(i)], pulsesf];
% phases = [phasesi, phases1, phasesf];
% delays = [delaysi, delays1, delaysf];

for functionIndex = 1 : 4
    for readoutNuc = 'CH'
        if(functionIndex == 1)
            % For function f1
            pulses = [pulsesi, pulses1, pulsesf];
            phases = [phasesi, phases1, phasesf];
            delays = [delaysi, delays1, delaysf];
        elseif(functionIndex == 2)
            % For function f2
            pulses = [pulsesi, pulses2, pulsesf];
            phases = [phasesi, phases2, phasesf];
            delays = [delaysi, delays2, delaysf];
        elseif(functionIndex == 3)
            % For function f3
            pulses = [pulsesi, pulses3, pulsesf];
            phases = [phasesi, phases3, phasesf];
            delays = [delaysi, delays3, delaysf];
        elseif(functionIndex == 4)
            % For function f4
            pulses = [pulsesi, pulses4, pulsesf];
            phases = [phasesi, phases4, phasesf];
            delays = [delaysi, delays4, delaysf];
        end
        
        % For reading
        if (readoutNuc == 'H')
            pulses = [pulses, read{1}];
            phases = [phases, [0;0]];
            delays = [delays, 0];
            nucflag = 1;
        elseif (readoutNuc == 'C')
            pulses = [pulses, read{2}];
            phases = [phases, [0;0]];
            delays = [delays, 0];
            nucflag = 2;
        end
        
        % Initialize pure states
        if(tavgflag == 1)
            pulses = [init{stateIndex}, pulses];
            phases = [[0;0], phases];
            delays = [0, delays];
        end
        
        dj = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
        fileName = ['f', num2str(functionIndex), 'Pure', cell2mat(States(stateIndex)), 'Readout', readoutNuc, date, '.mat'];
        eval(['save ',fileName,' dj']);
    end
end