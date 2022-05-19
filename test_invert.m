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
imagesc(G)


seqG=diag(ones(1,nd-1),1)-diag(ones(1,nd));
seqG=seqG(1:end-1,:);

Ga=[G;1e-4*seqG];
Ga(end+1,1)=1;
Gg=inv(Ga'*Ga)*G';

dvec=reshape(unw,ni,130*220);
mod=Gg*dvec;
mod=reshape(mod,nd,130,220);

figure
for i=1:nd
imagesc(squeeze(mod(i,:,:)))
colorbar
pause
end
