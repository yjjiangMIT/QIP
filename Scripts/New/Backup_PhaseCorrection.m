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