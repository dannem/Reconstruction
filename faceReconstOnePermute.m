function [recon_mat]=faceReconstOnePermute(CIsel_bin,loads,ims_train)
%% Converting my matrices to Adrian's format
% Converting image matrix into 2-D
CIsel_bin=CIsel_bin(1,:,:);
CIsel_bin=sum(CIsel_bin,3);

% if no signficant dimension, then first
replace_ind=sum(CIsel_bin, 2)==0; %60 x 1 x 3. looks for images X channels with no sig dimenstions
CIsel_bin(replace_ind, 1)=1;

% finding significant dimensions
CIsel_curr=find(CIsel_bin(1,:));
dim_sel=size(CIsel_curr, 2);


id_max=size(loads,1);

im_mat_train=[];
for i=1:size(ims_train,1)% converting image cell array to 2D array
    temp=ims_train{i};
    temp=rgb2lab(temp);
    temp=double(temp(:));
    im_mat_train=[im_mat_train temp];
end
% Converting bin matrices
[sz, ~]=size(im_mat_train);
recon_mat=NaN(sz, id_max);
ind_train=1:size(ims_train,1);

for ind_k=1:id_max
    
    Y_curr=squeeze(loads(ind_k,:,:));
    Y_L1out=Y_curr(ind_train,:);
    
    Y_L1out_sel=Y_L1out(:, CIsel_curr); %choosing only sig loadings
    dist_L1out_sel=sqrt(sum(Y_L1out_sel(:, 1:dim_sel).^2, 2));
    dist_L1out_sel_sc=dist_L1out_sel.*(1/sum(dist_L1out_sel, 1));
    im_mn=sum(im_mat_train .* repmat(dist_L1out_sel_sc', [sz 1]), 2);
    CI_mat=NaN(sz, dim_sel);
    
    %% face constr
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for dim_k=1:dim_sel
        
        ind_pos=find(Y_L1out_sel(:,dim_k)>0);
        ind_neg=find(Y_L1out_sel(:,dim_k)<0);
        
        ims_pos=im_mat_train(:, ind_pos);
        ims_neg=im_mat_train(:, ind_neg);
        
        Y_pos=Y_L1out_sel(ind_pos,dim_k);
        Y_neg=-Y_L1out_sel(ind_neg,dim_k);
        
        Y_pos_mat=repmat(Y_pos', [sz 1]);
        Y_neg_mat=repmat(Y_neg', [sz 1]);
        
        %%%prots - unscaled here
        prot_pos=sum(ims_pos.*Y_pos_mat, 2);
        prot_neg=sum(ims_neg.*Y_neg_mat, 2);
        
        CI=prot_pos-prot_neg;
      
        cf=Y_curr(size(Y_curr,1), CIsel_curr(dim_k));
        CI_mat(:, dim_k)=cf*CI/2;
        
    end
    
    
    recon_im=im_mn+sum(CI_mat, 2);
    recon_mat(:,ind_k)=recon_im;
    
end


