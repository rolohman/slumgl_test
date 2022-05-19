dates=load('dates.txt');
dst=num2str(dates);
dn=datenum(dst,'yyyymmdd');
dn0=datenum(dst(:,1:4),'yyyy');

doy = dn-dn0;

nd = length(dn);


dpci=readNPY('YEM_corrected/DPCI_max_YEM_Slum_T12502_longer_TB_final.npy');
rmse=readNPY('YEM_corrected/RMSE_min_YEM_Slum_T12502_longer_TB_final.npy');
unw=readNPY('YEM_corrected/unw_corrected_tot_YEM_Slum_T12502_longer_TB_final.npy');

id=find(and(dpci>=0.15,rmse<=1.65));
unw=unw(id,:,:);
pairs=load('YEM_corrected/yusuf_pairs.txt');
pairs=pairs(id,:);

p1=pairs(:,1);
p2=pairs(:,2);
dt=dn(p2)-dn(p1);

ni = length(pairs);

G=zeros(ni,nd);
for i=1:ni
    G(i,p1(i))=-1;
    G(i,p2(i))=1;
end
figure,imagesc(G)


seqG=diag(ones(1,nd-1),1)-diag(ones(1,nd));
seqG=seqG(1:end-1,:);

ida=find(sum(G==-1,1)==0);
idb=find(sum(G==1,1)==0);


Ga=G;
Ga(end+1,1)=1;
p=27;
[u,e,v]=svd(Ga);
up=u(:,1:p);
ep=e(1:p,1:p);
vp=v(:,1:p);
%svd Gg
Gg = vp*inv(ep)*up';


% Ga=[G;8e-7*seqG];
% Ga(end+1,1)=1;
%Gg=inv(Ga'*Ga)*G';

dvec=reshape(unw,ni,130*220);
dvec(end+1,:)=0;
def=Gg*dvec;



G2=[dn-dn(1) ones(size(dn))];
Gg2=inv(G2'*G2)*G2';
linefit=Gg2*def;
synth=G2*linefit;
synth=reshape(synth,nd,130,220);

rates=reshape(linefit(1,:),130,220);
def=reshape(def,nd,130,220);

figure
for i=1:ni
set(gcf,'name',[num2str(dates(p1(i),:)) '-' num2str(dates(p2(i),:))])
subplot(2,2,1)
imagesc(squeeze(unw(i,:,:)))
colorbar('h')
cax=caxis;
subplot(2,2,2)
int=squeeze(def(p2(i),:,:)-def(p1(i),:,:));
imagesc(int)
colorbar('h')
caxis(cax)
subplot(2,2,3)
imagesc(squeeze(unw(i,:,:))-int)
colorbar('h')
subplot(2,2,4)
imagesc(squeeze(mod(unw(i,:,:),2*pi)))
caxis([0 2*pi])
colorbar('h')
pause
end

return



figure
for i=1:nd
    m1=squeeze(def(i,:,:));
    s1=squeeze(synth(i,:,:));
    r1=m1-s1;
    subplot(1,3,1)    
    imagesc(m1)
    cax=caxis;
    colorbar('h')
    subplot(1,3,2)
    imagesc(s1)
    colorbar('h')
    caxis(cax)
    subplot(1,3,3)
    imagesc(r1)
    colorbar('h')
    pause
end
