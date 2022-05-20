nt=8;
dn=rand(nt,1);
dn=sort(dn);
dn=dn-min(dn)+1/dn/2;
dn=dn/max(dn)*10;


Var = 1;
nd=length(dn);
v0=1;
def=v0*dn;
noise=sqrt(Var)*randn(nd,10000);
defn=def+noise;


Gdef=-1*eye(nd)+diag(ones(nd-1,1),1);
Gdef=Gdef(1:end-1,:);
ni=size(Gdef,1);

vel=diff(def);
veln=diff(defn);
dt=diff(dn);
nv=length(dt);

Gvel=diag(dt);



skip=[3 5];
skip=[];
good=setdiff(1:ni,skip);

Gdef=Gdef(good,:);
Gvel=Gvel(good,:);
ni = length(good);

ints=[Gdef*defn];
Ga=Gdef;
Ga(end+1,1)=1;

[u,e,v]=svd(Gvel);
de=diag(e);
id=find(de>0);
p=id(end);

up=u(:,1:p);
ep=e(1:p,1:p);
vp=v(:,1:p);
%svd Gg
Ggsvd = vp*inv(ep)*up';

R=vp*vp';
modR=diag(R);
id=find(modR<0.8); %time intervals with no constraint
goodi=setdiff(1:nv,id);
goodcount=length(goodi);
gooddt = dt(goodi);
gooddt = gooddt/sum(gooddt);

Gvela=Gvel;
for i=1:length(id)
    Gvela(end+1,id(i))=1;
    Gvela(end,goodi)=-1/goodcount;
end

Gvelb=Gvel;
for i=1:length(id)
    Gvelb(end+1,id(i))=1;
    Gvelb(end,goodi)=-gooddt;
end

Gga=inv(Gvela'*Gvela)*Gvel';
Ggb=inv(Gvelb'*Gvelb)*Gvel';


covi=Var*Gdef*Gdef';
W=inv(covi);
G1=gooddt;
Ggc=inv(G1'*W*G1)*G1'*W;
avgr=Ggc*ints(goodi,:);

% 




moda   = Gga*ints;
modb   = Ggb*ints;
modc   = Ggc*ints;
modsvd = Ggsvd*ints;


meanmoda=mean(moda,2);
meanmodb=mean(modb,2);
meanmodc=mean(modc,2);
meanmodsvd=mean(modsvd,2);
stdmoda=std(moda,[],2);
stdmodb=std(modb,[],2);
stdmodc=std(modc,[],2);
stdmodsvd=std(modsvd,[],2);

dns=[dn(1:end-1) dn(2:end)]';

figure
plot([0 10],[v0 v0],'-','color',[0.5 0.5 0.5],'linewidth',3)
hold on
plot(dns(:,skip),zeros(2,length(skip)),'m','linewidth',3);
plot(dns,[meanmoda meanmoda]','r-');
plot(dns(:,skip),(meanmoda(skip)+stdmoda(skip))*[1 1],'r')
plot(dns(:,skip),(meanmoda(skip)-stdmoda(skip))*[1 1],'r')
plot(dns,[meanmodb meanmodb]','g-');
plot(dns(:,skip),(meanmodb(skip)+stdmodb(skip))*[1 1],'g')
plot(dns(:,skip),(meanmodb(skip)-stdmodb(skip))*[1 1],'g')
plot(dns,[meanmodc meanmodc]','c-');
plot(dns(:,skip),(meanmodc(skip)+stdmodc(skip))*[1 1],'c')
plot(dns(:,skip),(meanmodc(skip)-stdmodc(skip))*[1 1],'c')
plot(dns,[meanmodsvd meanmodsvd]','b-')
%plot(dns,meanmodsvd+stdmodsvd,'b:')
%plot(dns,meanmodsvd-stdmodsvd,'b:')



disp(['means: ' num2str(mean(moda(skip(1),:))) ' ' num2str(mean(modb(skip(1),:))) ' ' num2str(mean(modc(skip(1),:)))])
disp(['stds: ' num2str(std(moda(skip(1),:))) ' ' num2str(std(modb(skip(1),:))) ' ' num2str(std(modc(skip(1),:)))])

