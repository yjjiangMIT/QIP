function [ spectCorrected ] = simpPhaseCorrForOneNuc( spect, flag, sign )

spectCorrected = spect;
if( flag=='C' )
    spectCorrected.cspect = abs(spect.cspect);
    
    array1 = spectCorrected.cspect(1:end/2);
    baseline1 = (sum(array1(1:350)) + sum(array1(end-199:end))) / 550;
    array1 = array1 - baseline1;
    peakInt1 = (sum(array1)-array1(1)*0.5-array1(end)*0.5) * (spect.cfreq(2)-spect.cfreq(1));
    
    array2 = spectCorrected.cspect(end/2+1:end);
    baseline2 = (sum(array2(1:200)) + sum(array2(end-349:end))) / 550;
    array2 = array2 - baseline2;
    peakInt2 = (sum(array2)-array2(1)*0.5-array2(end)*0.5) * (spect.cfreq(2)-spect.cfreq(1));
    
    switch(sign)
        case 11
            spectCorrected.cpeaks = [peakInt1, peakInt2];
            spectCorrected.cspect = [array1; array2];
        case 1-1
            spectCorrected.cpeaks = [peakInt1, -peakInt2];
            spectCorrected.cspect = [array1; -array2];
        case -11
            spectCorrected.cpeaks = [-peakInt1, peakInt2];
            spectCorrected.cspect = [-array1; array2];
        case -1-1
            spectCorrected.cpeaks = [-peakInt1, -peakInt2];
            spectCorrected.cspect = [-array1; -array2];
    end
elseif( flag=='H' )
    spectCorrected.hspect = abs(spect.hspect);
    
    array1 = spectCorrected.hspect(1:end/2);
    baseline1 = (sum(array1(1:350)) + sum(array1(end-199:end))) / 550;
    array1 = array1 - baseline1;
    peakInt1 = (sum(array1)-array1(1)*0.5-array1(end)*0.5) * (spect.hfreq(2)-spect.hfreq(1));
    
    array2 = spectCorrected.hspect(end/2+1:end);
    baseline2 = (sum(array2(1:200)) + sum(array2(end-349:end))) / 550;
    array2 = array2 - baseline2;
    peakInt2 = (sum(array2)-array2(1)*0.5-array2(end)*0.5) * (spect.hfreq(2)-spect.hfreq(1));
    
    switch(sign)
        case 11
            spectCorrected.hpeaks = [peakInt1, peakInt2];
            spectCorrected.hspect = [array1; array2];
        case 1-1
            spectCorrected.hpeaks = [peakInt1, -peakInt2];
            spectCorrected.hspect = [array1; -array2];
        case -11
            spectCorrected.hpeaks = [-peakInt1, peakInt2];
            spectCorrected.hspect = [-array1; array2];
        case -1-1
            spectCorrected.hpeaks = [-peakInt1, -peakInt2];
            spectCorrected.hspect = [-array1; -array2];
    end
end