function [p_happ,p_neut]= ImClassOnePermut(imsTest,conf,perm_n,bck,dimNum)
%% based on CI_eval_node2.m
% Arguments:
%     images - cell array with images
%     loadings - results from parMDS function. Either 2D (identities X dims)...
%                 or 3D for leave one out (identites X dims x identities)
%     perm_n - number of desired permutations
%     leaveOut - 1 if you want to use a leave out procedure
%     bck - indices for background pixels for one image and one color channel
% Outputs:
%     p_hap - single matrix with p-values based on permutation test
%                 (Pixels X dims X ids) for happy
%     p_neut - single matrix with p-values based on permutation test
%                 (Pixels X dims X ids) for neutral
%
%% Prparation
tic
rng('shuffle')
[Y_proj,~,~,~,~]=patMDS(conf,dimNum,0.0001);
[imsTst,sizeIm]=cell2matIms(imsTest);
if prod(sizeIm)~=max(bck)
    error('Background index is not matching the images')
else
    sizeIm=sizeIm(1:3);
end

for i=1:size(imsTst,4)
    imsTst(:,:,:,i)=rgb2lab(imsTst(:,:,:,i));
end

imsTst=double(reshape(imsTst,prod(sizeIm),size(imsTst,4)));
ones_ind=setdiff(1:max(bck),bck)';
imsTst=imsTst(ones_ind,:);
sz=size(imsTst,1);

Y_L1out=zscore(Y_proj);
tstIdNum=size(Y_L1out,1);
%% computing permutations

pval_CI_neut_mat=NaN(sz, dimNum, size(imsTst,2));
pval_CI_happ_mat=NaN(sz, dimNum, size(imsTst,2));
for dim_k=1:dimNum;
    CI_mat_neut=NaN(sz, perm_n);
    CI_mat_happ=NaN(sz, perm_n);
    parfor perm_k=1:perm_n+1
        if perm_k>1
            ind_rand=randperm(tstIdNum)';
            Y_rnd=Y_L1out(ind_rand,dim_k);
        else
            Y_rnd=Y_L1out(:,dim_k);
        end
        %
        ind_pos=find(Y_rnd(:,1)>0);
        ind_neg=find(Y_rnd(:,1)<0);
        
        im_mat_pos_neut=imsTst(:, ind_pos+tstIdNum);
        im_mat_neg_neut=imsTst(:, ind_neg+tstIdNum);
        im_mat_pos_hap=imsTst(:, ind_pos);
        im_mat_neg_hap=imsTst(:, ind_neg);
        
        Y_pos=Y_rnd(ind_pos,1);
        Y_neg=-Y_rnd(ind_neg,1);
        
        Y_pos_mat=repmat(Y_pos', [sz 1]);
        Y_neg_mat=repmat(Y_neg', [sz 1]);
        
        %%%prots - unscaled here
        prot_pos_neut=sum(im_mat_pos_neut.*Y_pos_mat, 2);
        prot_neg_neut=sum(im_mat_neg_neut.*Y_neg_mat, 2);
        prot_pos_hap=sum(im_mat_pos_hap.*Y_pos_mat, 2);
        prot_neg_hap=sum(im_mat_neg_hap.*Y_neg_mat, 2);
        %
        CI_mat_neut(:,perm_k)=prot_pos_neut-prot_neg_neut;
        CI_mat_happ(:,perm_k)=prot_pos_hap-prot_neg_hap;
        %
        %
    end
    %
    pval_vect_neut=comp_pval(CI_mat_neut);
    pval_vect_hap=comp_pval(CI_mat_happ);
    pval_CI_neut_mat(:, dim_k)=pval_vect_neut;
    pval_CI_happ_mat(:, dim_k)=pval_vect_hap;
    %
end
p_happ=squeeze(single(pval_CI_happ_mat));
p_neut=squeeze(single(pval_CI_neut_mat));
toc
end
%
%
%
%
% %% computes signif based on permutation test
function pval_vect=comp_pval(CI_mat)
szm=size(CI_mat,1);
perm_nm=size(CI_mat,2);
tmp_sort=sort(abs(CI_mat), 2, 'descend');
tmp_act=abs(CI_mat(:,1));
rnk_vect=NaN(szm,1);
for val_k=1:szm
    rnk_vect(val_k, 1)=find(tmp_act(val_k,1)==tmp_sort(val_k,:), 1, 'last');
end
pval_vect=rnk_vect/perm_nm;
pval_vect=pval_vect/2;%%1-tailed
end

function [matOut,szIm]=cell2matIms(cellIn)
if iscell(cellIn)
else
    error('The argument does not contain a legal cell array')
end
szIm=size(cellIn{1});
for g=1:length(cellIn)
    matOut(:,:,:,g)=cellIn{g};
end
end
