function protoMDS(imCellIn,Y,flipSt)
% This function is used for visualization.
% Input: stimuli cell array; loadings; flipST -whether augment the results
% by flipping left and right.
% Functions is written by DN. Based on MDS_neur_patt_v2
if nargin<2;
    error(error(message('Please provide images and loading matrices')));
elseif nargin<3
    display('No flipping of the image is performed');
    flipSt=0;
end
ims_new=[];
for i=1:size(imCellIn,1)
    ims_new=cat(4,ims_new,imCellIn{i});
end
for dim_k=1:2
    
    ind_pos=find(Y(:,dim_k)>0);
    ind_neg=find(Y(:,dim_k)<0);
    Y_pos_scale=Y(ind_pos,dim_k)/sum(Y(ind_pos,dim_k));
    Y_neg_scale=-Y(ind_neg,dim_k)/sum(-Y(ind_neg,dim_k));
    
    
    im_mat_pos_neut=ims_new(:,:,:,ind_pos+60);
    im_mat_neg_neut=ims_new(:, :, :,ind_neg+60);
    im_mat_pos_hap=ims_new(:,:,:,ind_pos);
    im_mat_neg_hap=ims_new(:,:,:,ind_neg);
    
    Y_pos_scale_mat=permute(Y_pos_scale, [2 3 4 1]);
    Y_pos_scale_mat=repmat(Y_pos_scale_mat, [size(ims_new,1) size(ims_new,2) size(ims_new,3) 1]);
    
    Y_neg_scale_mat=permute(Y_neg_scale, [2 3 4 1]);
    Y_neg_scale_mat=repmat(Y_neg_scale_mat, [size(ims_new,1) size(ims_new,2) size(ims_new,3) 1]);
    
    prot_pos_neut=uint8(sum(double(im_mat_pos_neut).*Y_pos_scale_mat, 4));
    prot_neg_neut=uint8(sum(double(im_mat_neg_neut).*Y_neg_scale_mat, 4));
    prot_pos_hap=uint8(sum(double(im_mat_pos_hap).*Y_pos_scale_mat, 4));
    prot_neg_hap=uint8(sum(double(im_mat_neg_hap).*Y_neg_scale_mat, 4));
    
    if flipSt
        prot_pos_neut=uint8(mean(cat(4,prot_pos_neut,flipdim(prot_pos_neut,2)),4));
        prot_neg_neut=uint8(mean(cat(4,prot_neg_neut,flipdim(prot_neg_neut,2)),4));
        prot_pos_hap=uint8(mean(cat(4,prot_pos_hap,flipdim(prot_pos_hap,2)),4));
        prot_neg_hap=uint8(mean(cat(4,prot_neg_hap,flipdim(prot_neg_hap,2)),4));
    else
    end
    imwrite(prot_pos_neut,['prot_pos_neut_' 'dim' num2str(dim_k) '.tif']);
    imwrite(prot_neg_neut,['prot_neg_neut_' 'dim' num2str(dim_k) '.tif']);
    imwrite(prot_pos_hap,['prot_pos_hap_' 'dim' num2str(dim_k) '.tif']);
    imwrite(prot_neg_hap,['prot_neg_hap_' 'dim' num2str(dim_k) '.tif']);

    
end


