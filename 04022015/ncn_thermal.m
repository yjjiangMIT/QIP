
split = 
pulses = [0 0 1; 1 1 0];
phases = [0 0 0; 0 3 0];
delays = [1/split 0 0];
tavgflag = 0;
nucflag = 1;
sd = NMRRunPulseProg([7.5051 9.3434],[0 0], pulses, phases, delays, tavgflag,nucflag);
spect = NMRCalib(5,[0,0]);

%correct phase/ peaks

phaseCorrection( folderDir, phaseFileName, sd);
phaseCorrection( folderDir, phaseFileName, spect);

ratio = [sd.hpeaks./spect.hpeaks sd.cpeaks./spect.cpeaks]
