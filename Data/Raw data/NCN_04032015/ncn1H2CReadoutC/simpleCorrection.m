flag = 'C';
ratioActual = [10/2, -6/2];
load('workspace.mat');
sign = str2num([num2str(ratioActual(1)/abs(ratioActual(1))), num2str(ratioActual(2)/abs(ratioActual(2)))]);

if(flag == 'C')
    simpThermCCorr = simpPhaseCorrForOneNuc( thermal, flag, 11 );
    simpNCNCCorr = simpPhaseCorrForOneNuc( ncn, flag, sign );
    
    figure;
    plot(simpThermCCorr.cfreq, simpThermCCorr.cspect);
    title('Thermal');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    
    figure;
    plot(simpNCNCCorr.cfreq, simpNCNCCorr.cspect);
    title('Near CNOT');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    
    ratioSimpCorr = simpNCNCCorr.cpeaks./simpThermCCorr.cpeaks;
elseif(flag == 'H')
    simpThermHCorr = simpPhaseCorrForOneNuc( thermal, flag, 11 );
    simpNCNHCorr = simpPhaseCorrForOneNuc( ncn, flag, sign );
    
    figure;
    plot(simpThermHCorr.hfreq, simpThermHCorr.hspect);
    title('Thermal');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    
    figure;
    plot(simpNCNHCorr.hfreq, simpNCNHCorr.hspect);
    title('Near CNOT');
    xlabel('Frequency [Hz]');
    ylabel('Intensity [arb. units]');
    
    ratioSimpCorr = simpNCNHCorr.hpeaks./simpThermHCorr.hpeaks;
end

save('workspaceSimpCorr.mat');