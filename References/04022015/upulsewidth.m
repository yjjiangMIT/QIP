x = pwtab';
y1 = peaks(:,1);
y2 = peaks(:,3);

y = y2;

p = polyfit(x,y,4);
yfit = polyval(p,x);

position = find(yfit==max(yfit));
width = pwtab(position)


