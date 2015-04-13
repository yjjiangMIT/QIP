% Performs CNOT gate on the four pure states |00>, |01>, |10> and |11>.
% Loops over all qubit sequences and readout nuclei.
% qubitSeq: which qubit is used to control which.
% readoutNuc: which qubit is the readout.
% Output structs into files.
% Example file name: CNOT_Pure00Seq1C2HReadoutH0408.mat.

J = 214.94;
qubitSeqArray = {'1C2H'};
readoutNucArray = 'CH';
States = {'00', '01', '10', '11'};
date = '0409';
load(['T90Data/T90Rough_', date, '.mat']);

for i = 1 : lengthof(States)
    pureState = cell2mat(States(i));
    for j = 1 : lengthof(qubitSeqArray)
        qubitSeq = cell2mat(qubitSeqArray(j));
        for k = 1 : lengthof(readoutNucArray)
            readoutNuc = readoutNucArray(k);
            if(strcmp(qubitSeq, '1C2H'))
                if(readoutNuc == 'C')
                    if(strcmp(pureState, '00'))
                        pulses = [1 1 1 0 0 0 0; 0 0 0 1 1 1 1];
                        phases = [2 1 0 0 0 0 0; 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    elseif(strcmp(pureState, '01'))
                        pulses = [0 1 1 1 0 0 0 0; 2 0 0 0 1 1 1 1];
                        phases = [0 2 1 0 0 0 0 0; 0 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    elseif(strcmp(pureState, '10'))
                        pulses = [2 1 1 1 0 0 0 0; 0 0 0 0 1 1 1 1];
                        phases = [0 2 1 0 0 0 0 0; 0 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    elseif(strcmp(pureState, '11'))
                        pulses = [2 1 1 1 0 0 0 0; 2 0 0 0 1 1 1 1];
                        phases = [0 2 1 0 0 0 0 0; 0 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    end
                elseif(readoutNuc == 'H')
                    if(strcmp(pureState, '00'))
                        pulses = [1 1 1 0 0 0 1; 0 0 0 1 1 1 0];
                        phases = [2 1 0 0 0 0 0; 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    elseif(strcmp(pureState, '01'))
                        pulses = [0 1 1 1 0 0 0 1; 2 0 0 0 1 1 1 0];
                        phases = [0 2 1 0 0 0 0 0; 0 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    elseif(strcmp(pureState, '10'))
                        pulses = [2 1 1 1 0 0 0 1; 0 0 0 0 1 1 1 0];
                        phases = [0 2 1 0 0 0 0 0; 0 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    elseif(strcmp(pureState, '11'))
                        pulses = [2 1 1 1 0 0 0 1; 2 0 0 0 1 1 1 0];
                        phases = [0 2 1 0 0 0 0 0; 0 0 0 0 0 1 3 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    end
                end
            elseif(strcmp(qubitSeq, '1H2C'))
                if(readoutNuc == 'H')
                    if(strcmp(pureState, '00'))
                        pulses = [0 0 0 1 1 1 1; 1 1 1 0 0 0 0];
                        phases = [0 0 0 0 1 3 0; 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    elseif(strcmp(pureState, '01'))
                        pulses = [2 0 0 0 1 1 1 1; 0 1 1 1 0 0 0 0];
                        phases = [0 0 0 0 0 1 3 0; 0 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    elseif(strcmp(pureState, '10'))
                        pulses = [0 0 0 0 1 1 1 1; 2 1 1 1 0 0 0 0];
                        phases = [0 0 0 0 0 1 3 0; 0 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    elseif(strcmp(pureState, '11'))
                        pulses = [2 0 0 0 1 1 1 1; 2 1 1 1 0 0 0 0];
                        phases = [0 0 0 0 0 1 3 0; 0 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 1;
                        thermalTime = T90H;
                    end
                elseif(readoutNuc == 'C')
                    if(strcmp(pureState, '00'))
                        pulses = [0 0 0 1 1 1 0; 1 1 1 0 0 0 1];
                        phases = [0 0 0 0 1 3 0; 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    elseif(strcmp(pureState, '01'))
                        pulses = [2 0 0 0 1 1 1 0; 0 1 1 1 0 0 0 1];
                        phases = [0 0 0 0 0 1 3 0; 0 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    elseif(strcmp(pureState, '10'))
                        pulses = [0 0 0 0 1 1 1 0; 2 1 1 1 0 0 0 1];
                        phases = [0 0 0 0 0 1 3 0; 0 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    elseif(strcmp(pureState, '11'))
                        pulses = [2 0 0 0 1 1 1 0; 2 1 1 1 0 0 0 1];
                        phases = [0 0 0 0 0 1 3 0; 0 2 1 0 0 0 0 0];
                        delays = [0 0 0 0 0 1/2/J*1000 0 0];
                        tavgflag = 1;
                        nucflag = 2;
                        thermalTime = T90C;
                    end
                end
            end
            cn = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
            fileName = ['CNOT_Pure', pureState, 'Seq', qubitSeq, 'Readout', readoutNuc, date, '.mat'];
            eval(['save ',fileName,' cn']);
        end
    end
end