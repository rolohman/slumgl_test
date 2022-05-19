good=[1 8 21 50 60 62 65 70];
near=[9 12 27 28 30 35 44 61 74];


dates=load('dates.txt');
dst=num2str(dates);
dn=datenum(dst,'yyyymmdd');
dn0=datenum(dst(:,1:4),'yyyy');

doy = dn-dn0;

nd = length(dn);

load test
load pairs.txt
p1=pairs(:,1);
p2=pairs(:,2);
dt=dn(p2)-dn(p1);

dt(good)
dt(near)