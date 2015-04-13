% Failure trying to measure four entangled states.
% I forget the cross terms in the density matrices!
% This code will NOT produce entangled measurements.

% From Wikipedia: More recent work shows that all experiments
% in liquid state bulk ensemble NMR quantum computing to date
% do not possess quantum entanglement.

% (1) |Psi+> = (|00>+|11>) / sqrt(2).
% (2) |Psi-> = (|00>-|11>) / sqrt(2).
% (3) |Phi+> = (|01>+|10>) / sqrt(2).
% (4) |Phi-> = (|01>-|10>) / sqrt(2).
% Loops over all readout nuclei.
% entState: which entangled state.
% readoutNuc: which qubit is the readout.
% Output structs into files.
% Example file name: entStatePsiPlusSeq1C2HReadoutH0410.mat.

J = 215;
entArray = {'PsiPlus', 'PsiMinus', 'PhiPlus', 'PhiMinus'};
readoutNucArray = 'CH';
date = '0409';
load(['T90Data/T90Rough_', date, '.mat']);

for i = 1 : lengthof(entArray)
    entState = cell2mat(entArray(i));
    for j = 1 : lengthof(readoutNucArray)
        readoutNuc = readoutNucArray(j);
        if(strcmp(entState, 'PsiPlus'))
            % |Psi+> = (|00>+|11>) / sqrt(2).
            if(readoutNuc == 'H')
                % Readout from H.
                pulses = [0 1 1; 2 0 0];
                phases = [0 1 0; 1 0 0];
                delays = [0 0 0];
                tavgflag = 1;
                nucflag = 1;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [0 1; 1 0];
                phases = [0 0; 3 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.hspect = (part1.hspect-part2.hspect) / sqrt(2);
                entangled.hpeaks = (part1.hpeaks-part2.hpeaks) / sqrt(2);
            elseif(readoutNuc == 'C')
                % Readout from C.
                pulses = [0 1 0; 2 0 1];
                phases = [0 1 0; 1 0 0];
                delays = [0 0 0];
                tavgflag = 1;
                nucflag = 2;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [0 0; 1 1];
                phases = [0 0; 3 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 2;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.cspect = (part1.cspect-part2.cspect) / sqrt(2);
                entangled.cpeaks = (part1.cpeaks-part2.cpeaks) / sqrt(2);
            end
        elseif(strcmp(entState, 'PsiMinus'))
            % |Psi-> = (|00>-|11>) / sqrt(2).
            if(readoutNuc == 'H')
                % Readout from H.
                pulses = [0 2; 2 0];
                phases = [0 0; 0 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [0 1; 1 0];
                phases = [0 0; 2 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.hspect = (part1.hspect-part2.hspect) / sqrt(2);
                entangled.hpeaks = (part1.hpeaks-part2.hpeaks) / sqrt(2);
            elseif(readoutNuc == 'C')
                % Readout from C.
                pulses = [0 1 0; 2 0 1];
                phases = [0 0 0; 0 0 0];
                delays = [0 0 0];
                tavgflag = 1;
                nucflag = 2;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [];
                phases = [];
                delays = [];
                % pulses = [0 0; 1 1];
                % phases = [0 0; 2 0];
                % delays = [0 0];
                tavgflag = 1;
                nucflag = 2;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.cspect = (part1.cspect-part2.cspect) / sqrt(2);
                entangled.cpeaks = (part1.cpeaks-part2.cpeaks) / sqrt(2);
            end
        elseif(strcmp(entState, 'PhiPlus'))
            % |Phi+> = (|01>+|10>) / sqrt(2).
            if(readoutNuc == 'H')
                % Readout from H.
                pulses = [1 1; 0 0];
                phases = [1 0; 0 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [0 1; 1 0];
                phases = [0 0; 3 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.hspect = (part1.hspect-part2.hspect) / sqrt(2);
                entangled.hpeaks = (part1.hpeaks-part2.hpeaks) / sqrt(2);
            elseif(readoutNuc == 'C')
                % Readout from C.
                pulses = [1 0; 0 1];
                phases = [1 0; 0 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 2;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [0 0; 1 1];
                phases = [0 0; 3 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 2;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.cspect = (part1.cspect-part2.cspect) / sqrt(2);
                entangled.cpeaks = (part1.cpeaks-part2.cpeaks) / sqrt(2);
            end
        elseif(strcmp(entState, 'PhiMinus'))
            % |Phi-> = (|01>-|10>) / sqrt(2).
            if(readoutNuc == 'H')
                % Readout from H.
                pulses = [0 1; 1 0];
                phases = [0 0; 1 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [1 1; 0 0];
                phases = [1 0; 0 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 1;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.hspect = (part1.hspect-part2.hspect) / sqrt(2);
                entangled.hpeaks = (part1.hpeaks-part2.hpeaks) / sqrt(2);
            elseif(readoutNuc == 'C')
                % Readout from C.
                pulses = [0 0; 1 1];
                phases = [0 0; 1 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 2;
                part1 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                pulses = [1 0; 0 1];
                phases = [1 0; 0 0];
                delays = [0 0];
                tavgflag = 1;
                nucflag = 2;
                part2 = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
                
                entangled = part1;
                entangled.cspect = (part1.cspect-part2.cspect) / sqrt(2);
                entangled.cpeaks = (part1.cpeaks-part2.cpeaks) / sqrt(2);
            end
        end    
        fileName1 = ['part1EntState', entState, 'Seq1C2HReadout', readoutNuc, date, '.mat'];
        fileName2 = ['part2EntState', entState, 'Seq1C2HReadout', readoutNuc, date, '.mat'];
        fileName = ['entState', entState, 'Seq1C2HReadout', readoutNuc, date, '.mat'];
        save fileName1 part1;
        save fileName2 part2;
        save fileName entangled;
    end
end