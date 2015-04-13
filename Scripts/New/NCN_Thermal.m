% Performs near CNOT gate on the thermal state.
% Loops over all qubit sequences and readout nuclei.
% qubitSeq: which qubit is used to control which.
% readoutNuc: which qubit is the readout.
% Output structs into files.
% Example file name: NCN_ThermalSeq1C2HReadoutH0408.mat.

J = 214.94;
qubitSeqArray = {'1C2H', '1H2C'};
readoutNucArray = 'CH';
data = '0409';
load(['T90Data/T90Rough_', date, '.mat']);

for i = 1 : length(qubitSeqArray)
    qubitSeq = cell2mat(qubitSeqArray(i));
    for j = 1 : length(readoutNucArray)
        readoutNuc = readoutNucArray(j);
        if(strcmp(qubitSeq, '1C2H'))
            if(readoutNuc == 'C')
                pulses = [0 0 0; 1 1 1];
                phases = [0 0 0; 0 3 0];
                delays = [1/2/J*1000 0 0];
                tavgflag = 0;
                nucflag = 2;
                thermalTime = T90C;
            elseif(readoutNuc == 'H')
                pulses = [0 0 1; 1 1 0];
                phases = [0 0 0; 0 3 0];
                delays = [1/2/J*1000 0 0];
                tavgflag = 0;
                nucflag = 1;
                thermalTime = T90H;
            end
        elseif(strcmp(qubitSeq, '1H2C'))
            if(readoutNuc == 'C')
                pulses = [1 1 0; 0 0 1];
                phases = [0 3 0; 0 0 0];
                delays = [1/2/J*1000 0 0];
                tavgflag = 0;
                nucflag = 2;
                thermalTime = T90C;
            elseif(readoutNuc == 'H')
                pulses = [1 1 1; 0 0 0];
                phases = [0 3 0; 0 0 0];
                delays = [1/2/J*1000 0 0];
                tavgflag = 0;
                nucflag = 1;
                thermalTime = T90H;
            end
        end
        ncn = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
        fileName = ['NCN_ThermalSeq', qubitSeq, 'Readout', readoutNuc, date, '.mat'];
        eval(['save ',fileName,' ncn']);
    end
end