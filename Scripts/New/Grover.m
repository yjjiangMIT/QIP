% Performs Grover algorithm.
% Loops over all four functions and two readout nuclei.
% functionIndex: which function is used.
% readoutNuc: which qubit is the readout.
% Output structs into files.
% Example file name: g0For2TimesReadoutH0410.mat.


J = 214.94;
date = '0413';
load(['T90Data/T90Para_', date, '.mat']);
tavgflag = 1;

literation = ;

for round = 0 : iteration
    numberG = round; % How many times is G performed    
    for functionIndex = 0 : 3
        for readoutNuc = 'CH'
            if(readoutNuc == 'C')
                nucflag = 2;
            elseif(readoutNuc == 'H')
                nucflag = 1;
            end
            if(functionIndex == 0)
                % G0 = rx1*ry1*rx2*ry2*tau*rx1'*ry1'*rx2'*ry2'*tau
                pulsesG = [0 1 1 0 0 1 1 0 0; 0 0 0 1 1 0 0 1 1];
                phasesG = [0 3 2 0 0 1 0 0 0; 0 0 0 3 2 0 0 1 0];
                delaysG = [1/2/J*1000 0 0 0 1/2/J*1000 0 0 0 0];
            elseif(functionIndex == 1)
                % G1 = rx1'*ry1'*rx2*ry2*tau*rx1*ry1*rx2*ry2*tau
                pulsesG = [0 1 1 0 0 1 1 0 0; 0 0 0 1 1 0 0 1 1];
                phasesG = [0 1 0 0 0 1 0 0 0; 0 0 0 1 0 0 0 3 2];
                delaysG = [1/2/J*1000 0 0 0 1/2/J*1000 0 0 0 0];
            elseif(functionIndex == 2)
                % G2 = rx1*ry1*rx2'*ry2'*tau*rx1*ry1*rx2*ry2*tau
                pulsesG = [0 1 1 0 0 1 1 0 0; 0 0 0 1 1 0 0 1 1];
                phasesG = [0 1 0 0 0 3 2 0 0; 0 0 0 1 0 0 0 1 0];
                delaysG = [1/2/J*1000 0 0 0 1/2/J*1000 0 0 0 0];
            elseif(functionIndex == 3)
                % G3 = rx1'*ry1'*rx2'*ry2'*tau*rx1'*ry1'*rx2'*ry2'*tau
                pulsesG = [0 1 1 0 0 1 1 0 0; 0 0 0 1 1 0 0 1 1];
                phasesG = [0 3 2 0 0 3 2 0 0; 0 0 0 3 2 0 0 3 2];
                delaysG = [1/2/J*1000 0 0 0 1/2/J*1000 0 0 0 0];
            end

            % Hadamard tensor hardmard
            % H2 = rx1*rx1*ry1*rx2*rx2*ry2
            pulsesH = [1 2 0 0; 0 0 1 2];
            phasesH = [1 0 0 0; 0 0 1 0];
            delaysH = [0 0 0 0];

            % Readout pulse
            phasesR = [0; 0];
            delaysR = 0;     
            if(readoutNuc == 'H')
                pulsesR = [1; 0];
            elseif(readoutNuc == 'C')
                pulsesR = [0; 1];
            end

            % Concatenate pulses
            pulses = pulsesH;
            phases = phasesH;
            delays = delaysH;
            for i = 1 : numberG
                pulses = [pulses, pulsesG];
                phases = [phases, phasesG];
                delays = [delays, delaysG];
            end
            pulses = [pulses, pulsesR];
            phases = [phases, phasesR];
            delays = [delays, delaysR];

            % Perform Grover algorithm
            gr = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
            fileName = ['paraG', num2str(functionIndex), 'For', num2str(numberG), 'TimesReadout', readoutNuc, date, '.mat'];
            eval(['save ',fileName,' gr']);
        end
    end
end