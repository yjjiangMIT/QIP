figure;
hold on;

% load('CNOT_Pure0413Expsin/expsinCNOT_Pure11Seq1C2HReadoutC0413.mat');
% spectTemp = cn;
% PhaseCorrectionAbsC;
% cnCorr = spectTemp;
% plot(cnCorr.cfreq, cnCorr.cspect, 'b');
% load('CNOT_Pure0413Para/paraCNOT_Pure11Seq1C2HReadoutC0413.mat');
% spectTemp = cn;
% PhaseCorrectionAbsC;
% cnCorr = spectTemp;
% plot(cnCorr.cfreq, cnCorr.cspect, 'r');

% load('NCN_Pure0413Expsin/expsinNCN_Pure00Seq1C2HReadoutC0413.mat');
% spectTemp = ncn;
% PhaseCorrectionAbsC;
% ncnCorr = spectTemp;
% plot(ncnCorr.cfreq, ncnCorr.cspect, 'b');
% load('NCN_Pure0413Para/paraNCN_Pure00Seq1C2HReadoutC0413.mat');
% spectTemp = ncn;
% PhaseCorrectionAbsC;
% ncnCorr = spectTemp;
% plot(ncnCorr.cfreq, ncnCorr.cspect, 'r');

load('Grover_0413Expsin/expsinG3For1TimesReadoutH0413.mat');
spectTemp = gr;
PhaseCorrectionAbsH;
grCorr = spectTemp;
plot(grCorr.hfreq, grCorr.hspect, 'b');
load('Grover_0413Para/paraG3For1TimesReadoutH0413.mat');
spectTemp = gr;
PhaseCorrectionAbsH;
grCorr = spectTemp;
plot(grCorr.hfreq, grCorr.hspect, 'r');