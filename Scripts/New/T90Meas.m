peaks = [];
pwtab = linspace(1,15,15);

for pw = pwtab
    i = find(pwtab==pw);
    
    sd = NMRCalib(pw,[0,0]);
    close(figure(gcf));
end