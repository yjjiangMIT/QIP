pwtab = linspace(6,15,10);

for pw = pwtab
    i = find(pwtab == pw);
    spect = NMRCalib(pw, [0,0]);
    fileName = ['pulse', num2str(pw), 'us0409.mat'];
    eval(['save ',fileName,' spect']);
    close(figure(gcf));
end