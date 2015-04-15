% --------- Hydrogen ----------
pulses = [0 1; 0 0];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 1;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionH;
pureCorr = spectTemp;
figure;
plot(pureCorr.hfreq, pureCorr.hspect);
save expsinPure00ReadoutH_0414.mat pure

pulses = [0 1; 2 0];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 1;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionH;
pureCorr = spectTemp;
figure;
plot(pureCorr.hfreq, pureCorr.hspect);
save expsinPure01ReadoutH_0414.mat pure

pulses = [2 1; 0 0];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 1;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionH;
pureCorr = spectTemp;
figure;
plot(pureCorr.hfreq, pureCorr.hspect);
save expsinPure10ReadoutH_0414.mat pure

pulses = [2 1; 2 0];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 1;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionH;
pureCorr = spectTemp;
figure;
plot(pureCorr.hfreq, pureCorr.hspect);
save expsinPure11ReadoutH_0414.mat pure

% ---------- Carbon ----------
pulses = [0 0; 0 1];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 2;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionC;
pureCorr = spectTemp;
figure;
plot(pureCorr.cfreq, pureCorr.cspect);
save expsinPure00ReadoutC_0414.mat pure

pulses = [0 0; 2 1];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 2;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionC;
pureCorr = spectTemp;
figure;
plot(pureCorr.cfreq, pureCorr.cspect);
save expsinPure01ReadoutC_0414.mat pure

pulses = [2 0; 0 1];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 2;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionC;
pureCorr = spectTemp;
figure;
plot(pureCorr.cfreq, pureCorr.cspect);
save expsinPure10ReadoutC_0414.mat pure

pulses = [2 0; 2 1];
phases = [0 0; 0 0];
delays = [0 0];
tavgflag = 1;
nucflag = 2;
pure = NMRRunPulseProg([T90H T90C], [0 0], pulses, phases, delays, tavgflag, nucflag);
spectTemp = pure;
PhaseCorrectionC;
pureCorr = spectTemp;
figure;
plot(pureCorr.cfreq, pureCorr.cspect);
save expsinPure11ReadoutC_0414.mat pure


save expsinPure11ReadoutH_0414.mat pure