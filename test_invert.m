dates=load('dates.txt');
dn=datenum(num2str(dates),'yyyymmdd');
nd = length(dn);

%deleted 6 7 since doesn't exist
pairs=load('pairs.txt');
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

unws=nan(ni,dx,dy);

for i=1:ni
    pairname=['uav' num2str(p1(i)) '__uav' num2str(p2(i))];
    unwname=[pairname '/' pairname '_hh.filt_topophase.unw'];
    if(exist(unwname,'file'))
    fid=fopen(unwname,'r');
    fseek(fid,(y1-1)*nx*8,-1);
    tmp=fread(fid,[nx,dy*2],'real*4');
    unws(i,:,:)=tmp(x1:x2,2:2:end);
    else
        disp([unwname ' does not exist'])
    end
    
end