% PC0H = linspace(-360, 360, 100);
% PC1H = linspace(-360, 360, 100);
PC0H = linspace(-128, 129, 100);
PC1H = linspace(169, 170, 100);

xOpt = 0;
yOpt = 0;
for i = 1 : 100
    maximum = 0;
    for y = PC1H
        pvh = exp(1i*(xOpt+y*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);
        spectNew.hspect = pvh.*spect.hspect;
        array1 = spectNew.hspect(1:end/2);
        array2 = spectNew.hspect(end/2+1:end);
        quality = (max(real(array1))+max(real(array2)))/abs(max(real(array1))-max(real(array2)));
        if(quality > maximum)
            maximum = quality;
            yOpt = y;
        end
    end
    maximum = 0;
    for x = PC0H
        pvh = exp(1i*(x+yOpt*spect.hfreq/(spect.hfreq(end)-spect.hfreq(1)))*pi/180);
        spectNew.hspect = pvh.*spect.hspect;
        pos = find(real(spectNew.hspect)==max(real(spectNew.hspect)));
        realPart = real(spectNew.hspect(pos));
        imagPart = max(abs(imag(spectNew.hspect(pos-1:pos+1))));
        quality = realPart / imagPart;
        if(quality > maximum)
            maximum = quality;
            xOpt = x;
        end
    end
    deltaX = PC0H(2) - PC0H(1);
    deltaY = PC1H(2) - PC1H(1);
    PC0H = linspace(xOpt-deltaX*25, xOpt+deltaX*25, 100);
    PC1H = linspace(yOpt-deltaY*25, yOpt+deltaY*25, 100);
end

