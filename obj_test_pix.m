function [acc_detail,acc_aver]=obj_test_pix(recon_mat,ims,crit_mat,prcnt)
for i=1:length(ims)
    temp=ims{i};
    orig(:,i)=temp(:);
end
for i=1:size(recon_mat,4)
    temp=recon_mat(:,:,:,i);
    recon(:,i)=temp(:);
end
for i=1:length(crit_mat)
    temp=crit_mat{i};
    crit(:,i)=temp(:);
end
% crit=[crit;crit];

for i=1:size(recon,2)
    temp=crit(:,i);
    prc=prctile(temp,prcnt);
    cr=find(temp<prc);
    tempR=recon(:,i);
    tempR(cr)=0;
    tempO=orig;
    tempO(cr,:)=0;
    Eudis_same=sum((tempR-tempO(:,i)).^2,1);
    tempO(:,i)=[];
    for j=1:size(tempO,2)
        Eudis_other=sum((tempR-tempO(:,j)).^2,1);
        acc_detail(i,j)=Eudis_same<Eudis_other;
    end
end
acc_aver=mean(mean(acc_detail,2),1);
    
        
    
