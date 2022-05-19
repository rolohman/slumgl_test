dates=load('dates.txt');
dst=num2str(dates);
dn=datenum(dst,'yyyymmdd');
dn0=datenum(dst(:,1:4),'yyyy');

doy = dn-dn0;

nd = length(dn);

%deleted 6 7 since doesn't exist
pairs=load('offpairs.txt');
p1=pairs(:,1);
p2=pairs(:,2);
ni = length(pairs);

nx = 1565;
x1 = 678;
y1 = 1433;
x2 = 967;
y2 = 1626;

dx=x2-x1+1;
dy=y2-y1;

%go back and check for 12s
load test.mat %unw (ni,dx,dy)
unws=nan(ni,dx,dy);

G=zeros(ni,nd);
for i=1:ni
    G(i,p1(i))=-1;
    G(i,p2(i))=1;
end
%imagesc(G)
[u,e,v]=svd(G);
p=7; %??
up=u(:,1:p);
ep=e(1:p,1:p);
vp=v(:,1:p);
Gg_svd = vp*inv(ep)*up';

x=4206:12:5514;
y=24922:34:27098;
[Xg,Yg]=meshgrid(x,y);

offs=nan(ni,length(y),length(x));
%load data
for i = 1:ni
    filename=['offs_' num2str(p1(i)) '_' num2str(p2(i))];
    tmp=load(filename,'-ascii');
    lon=tmp(:,1);
    lat=tmp(:,3);
    ro = tmp(:,2);
    offs(i,:,:)=griddata(lon,lat,ro,Xg,Yg);

end

offs=reshape(offs,[ni,length(x)*length(y)]);
def=Gg_svd*offs;
    
return

Ga=G;
Ga(end+1,1)=1; %first date 0
Ga(end+1,12:13)=[-1 1]; %missing time interval = 0;

Gg=inv(Ga'*Ga)*G';

