J = 215;
qubitSeq = '1H2C';
readoutNuc = 'H';

if(strcmp(qubitSeq,'1C2H'))
    if(readoutNuc == 'C')
        pulses = [0 0 0;1 1 1];
        phases = [0 0 0;0 3 0];
        delays = [1/2/J*1000 0 0];
        tavgflag = 0;
        nucflag = 2;
        thermalTime = 9.33;
    elseif(readoutNuc == 'H')
        pulses = [0 0 1;1 1 0];
        phases = [0 0 0;0 3 0];
        delays = [1/2/J*1000 0 0];
        tavgflag = 0;
        nucflag = 1;
        thermalTime = 7.54;
    end
elseif(strcmp(qubitSeq,'1H2C'))
    if(readoutNuc == 'C')
        pulses = [1 1 0;0 0 1];
        phases = [0 3 0;0 0 0];
        delays = [1/2/J*1000 0 0];
        tavgflag = 0;
        nucflag = 2;
        thermalTime = 9.33;
    elseif(readoutNuc == 'H')
        pulses = [1 1 1;0 0 0];
        phases = [0 3 0;0 0 0];
        delays = [1/2/J*1000 0 0];
        tavgflag = 0;
        nucflag = 1;
        thermalTime = 7.54;
    end
end

ncn = NMRRunPulseProg([7.54 9.33], [0 0], pulses, phases, delays, tavgflag, nucflag);
thermal = NMRCalib(thermalTime, [0,0]);

% correct phase/ peaks
ncnCorrected = ncn;
thermalCorrected = thermal;

if(readoutNuc == 'H')
    pvh = exp(1i*(PC0H+PC1H*ncn.hfreq/(ncn.hfreq(end)-ncn.hfreq(1)))*pi/180);
    ncnCorrected.hspect = ncn.hspect.*pvh;
    pvh = exp(1i*(PC0H+PC1H*thermal.hfreq/(thermal.hfreq(end)-thermal.hfreq(1)))*pi/180);
    thermalCorrected.hspect = thermal.hspect.*pvh;
    pf = evalin('base','calib.pf');
    iw = evalin('base','calib.iwidth');
    hpeak = do_integral(ncnCorrected.hfreq, ncnCorrected.hspect, pf, iw, ncnCorrected.hsfo);
    ncnCorrected.hpeaks = hpeak(1:2);
    hpeak = do_integral(thermalCorrected.hfreq, thermalCorrected.hspect, pf, iw, thermalCorrected.hsfo);
    thermalCorrected.hpeaks = hpeak(1:2);
    figure;
    plot(ncnCorrected.hfreq, real(ncnCorrected.hspect));
    title('Near CNOT');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    figure;
    plot(thermalCorrected.hfreq, real(thermalCorrected.hspect));
    title('Thermal');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    ratio = [ncnCorrected.hpeaks./thermalCorrected.hpeaks]
elseif(readoutNuc == 'C')
    pvc = exp(1i*(PC0C+PC1C*ncn.cfreq/(ncn.cfreq(end)-ncn.cfreq(1)))*pi/180);
    ncnCorrected.cspect = ncn.cspect.*pvc;
    pvc = exp(1i*(PC0C+PC1C*thermal.cfreq/(thermal.cfreq(end)-thermal.cfreq(1)))*pi/180);
    thermalCorrected.cspect = thermal.cspect.*pvc;
    pf = evalin('base','calib.pf');
    iw = evalin('base','calib.iwidth');
    cpeak = do_integral(ncnCorrected.cfreq, ncnCorrected.cspect, pf, iw, ncnCorrected.csfo);
    ncnCorrected.cpeaks = cpeak(3:4);
    cpeak = do_integral(thermalCorrected.cfreq, thermalCorrected.cspect, pf, iw, thermalCorrected.csfo);
    thermalCorrected.cpeaks = cpeak(3:4);
    figure;
    plot(ncnCorrected.cfreq, real(ncnCorrected.cspect));
    title('Near CNOT');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    figure;
    plot(thermalCorrected.cfreq, real(thermalCorrected.cspect));
    title('Thermal');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    ratio = [ncnCorrected.cpeaks./thermalCorrected.cpeaks]
end