function fitLorentzian( spect )
% fitLorentzian( spect )
% Fit Lorentzian to Fourier peaks to find T2

global calib b1H b2H b1C b2C;
workspaceDir = 'C:\Users\Yijun\Desktop\QIP\Data\Workspace';
phaseFileName = 'phase_03312015';
calibName = 'calib_03312015';
calib = importdata([workspaceDir, '\', calibName, '.mat']);

spect = phaseCorrection(workspaceDir, phaseFileName, spect);

%%%%%%%%%% Hydrogen %%%%%%%%%%
realSpectH = real(spect.hspect);

pos1H = find(realSpectH(1:end/2)==max(realSpectH(1:end/2)));
pos2H = length(realSpectH)/2 + find(realSpectH(end/2:end)==max(realSpectH(end/2:end)));

width = 10;
freq1H = spect.hfreq(pos1H-width+1:pos1H+width+1);
freq2H = spect.hfreq(pos2H-width:pos2H+width);
spect1H = realSpectH(pos1H-width+1:pos1H+width+1);
spect2H = realSpectH(pos2H-width:pos2H+width);

fx = @(b,x) b(1)./((x-b(2)).^2+b(3)^2)+b(4);
b = [2.3e7, -107.6, 1.5, 0];
deltaB = b;
iteration = 0;
while norm(deltaB) > 1e-10 && iteration < 100
    b0 = b;
    b = lsqcurvefit(fx, b, freq1H, spect1H);
    b = nlinfit(freq1H, spect1H, fx, b);
    deltaB = b - b0;
    iteration = iteration + 1;
end
iteration
b1H = b;

fx = @(b,x) b(1)./((x-b(2)).^2+b(3)^2)+b(4);
b = [2.3e7, 107.5, 1.5, 0];
deltaB = b;
iteration = 0;
while norm(deltaB) > 1e-10 && iteration < 100
    b0 = b;
    b = lsqcurvefit(fx, b, freq2H, spect2H);
    b = nlinfit(freq2H, spect2H, fx, b);
    deltaB = b - b0;
    iteration = iteration + 1;
end
iteration
b2H = b;

figure;
plot(freq1H, spect1H);
title('First peak of hydrogen')
xlabel('Frequency [Hz]');
ylabel('Intensity [arb. units]');

figure;
plot(freq2H, spect2H);
title('Second peak of hydrogen')
xlabel('Frequency [Hz]');
ylabel('Intensity [arb. units]');

%%%%%%%%%% Carbon %%%%%%%%%%
realSpectC = real(spect.cspect);

pos1C = find(realSpectC(1:end/2)==max(realSpectC(1:end/2)));
pos2C = length(realSpectC)/2 + find(realSpectC(end/2:end)==max(realSpectC(end/2:end)));

width = 10;
freq1C = spect.cfreq(pos1C-width:pos1C+width);
freq2C = spect.cfreq(pos2C-width-1:pos2C+width-1);
spect1C = realSpectC(pos1C-width:pos1C+width);
spect2C = realSpectC(pos2C-width-1:pos2C+width-1);

fx = @(b,x) b(1)./((x-b(2)).^2+b(3)^2)+b(4);
b = [2.3e7, -107.6, 1.5, 0];
deltaB = b;
iteration = 0;
while norm(deltaB) > 1e-10 && iteration < 100
    b0 = b;
    b = lsqcurvefit(fx, b, freq1C, spect1C);
    b = nlinfit(freq1C, spect1C, fx, b);
    deltaB = b - b0;
    iteration = iteration + 1;
end
iteration
b1C = b;

fx = @(b,x) b(1)./((x-b(2)).^2+b(3)^2)+b(4);
b = [2.3e7, 107.5, 1.5, 0];
deltaB = b;
iteration = 0;
while norm(deltaB) > 1e-10 && iteration < 100
    b0 = b;
    b = lsqcurvefit(fx, b, freq2C, spect2C);
    b = nlinfit(freq2C, spect2C, fx, b);
    deltaB = b - b0;
    iteration = iteration + 1;
end
iteration
b2C = b;

figure;
plot(freq1C, spect1C);
title('First peak of carbon')
xlabel('Frequency [Hz]');
ylabel('Intensity [arb. units]');

figure;
plot(freq2C, spect2C);
title('Second peak of carbon')
xlabel('Frequency [Hz]');
ylabel('Intensity [arb. units]');