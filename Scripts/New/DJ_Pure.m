J = 214.94;
qubitSeq = '1C2H';
tavgflag = 1;
i = 1;
States = {'00', '01', '10', '11'};
date = '0409';
fArray = 1 : 4;
readoutNucArray = 'CH';

% Uf1: Identity
pulses1 = [];
phases1 = [];
delays1 = [];

% Uf2: NOT(y)
pulses2 = [0; 2];
phases2 = [0; 0];
delays2 = 0;

% Uf3: CNOT(x,y)
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

for f = fArray
    for readoutNuc = readoutNucArray
        if(f == 1)
            % For function f1
            pulses = [pulsesi, pulses1, pulsesf];
            phases = [phasesi, phases1, phasesf];
            delays = [delaysi, delays1, delaysf];
        elseif(f == 2)
            % For function f2
            pulses = [pulsesi, pulses2, pulsesf];
            phases = [phasesi, phases2, phasesf];
            delays = [delaysi, delays2, delaysf];
        elseif(f == 3)
            % For function f3
            pulses = [pulsesi, pulses3, pulsesf];
            phases = [phasesi, phases3, phasesf];
            delays = [delaysi, delays3, delaysf];
        elseif(f == 4)
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
            pulses = [init{i}, pulses];
            phases = [[0;0], phases];
            delays = [0, delays];
        end
        
        dj = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
        fileName = ['f', num2str(f), 'Pure', cell2mat(States(i)), 'Seq', qubitSeq, 'Readout', readoutNuc, date, '.mat'];
        eval(['save ',fileName,' dj']);
    end
end