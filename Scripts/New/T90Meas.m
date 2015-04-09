peaks = [];
pwtab = linspace(6,11,10);

for pw = pwtab
    i = find(pwtab==pw);
    
    sd = NMRCalib(pw,[0,0]);
    close(figure(gcf));
end