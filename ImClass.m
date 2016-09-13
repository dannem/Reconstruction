function [p_happ,p_neut,CI_happ,CI_neut]= ImClass(images,loadings,perm_n,bck,leaveOut)
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
temp=double(images{1});
if size(temp(:),1)~=max(bck);
    error('Background index is not matching the images')
end
ones_ind=1:max(bck);
ones_ind=setdiff(ones_ind,bck)';
im_mat=NaN(size(ones_ind,1),length(images));
for i=1:size(images,1)% converting image cell array to 2D array
    temp=double(images{i}(:));
    im_mat(:,i)=temp(ones_ind);
end


sz=size(im_mat,1);
CI_neut=NaN(size(im_mat,1),size(loadings,2));
CI_happ=NaN(size(im_mat,1),size(loadings,2));
CI_mat_neut=NaN(sz, perm_n);% matrix for permuations
CI_mat_happ=CI_mat_neut;
%% computing permutations
if ~leaveOut %for all identities at once
    Y_mat=zscore(loadings);
    for ROI_k=1:size(loadings,3);
        pval_CI_neut_mat=NaN(sz,size(loadings,2));
        pval_CI_hap_mat=pval_CI_neut_mat;
        for dim_k=1:size(loadings,2);%size(Y_mat, 2); % #dims for recon purposes
            parfor perm_k=1:perm_n+1
                if perm_k>1 % all but first layer are permuted.
                    ind_rand=randperm(length(Y_mat))';
                    Y_rnd=Y_mat(ind_rand,dim_k);
                else % first layer is not perumted (true)
                    Y_rnd=Y_mat(:,dim_k); 
                end
                
                ind_pos=find(Y_rnd(:,1)>0);
                ind_neg=find(Y_rnd(:,1)<0);
                
                
                im_mat_pos_neut=im_mat(:, ind_pos+size(loadings,1));
                im_mat_neg_neut=im_mat(:, ind_neg+size(loadings,1));
                im_mat_pos_hap=im_mat(:, ind_pos);
                im_mat_neg_hap=im_mat(:, ind_neg);
                
                
                Y_pos=Y_rnd(ind_pos,1);
                Y_neg=-Y_rnd(ind_neg,1);
                
                
                Y_pos_mat=repmat(Y_pos', [sz 1]);
                Y_neg_mat=repmat(Y_neg', [sz 1]);
                
                %%%prots - unscaled here
                prot_pos_neut=sum(im_mat_pos_neut.*Y_pos_mat, 2);
                prot_neg_neut=sum(im_mat_neg_neut.*Y_neg_mat, 2);
                prot_pos_hap=sum(im_mat_pos_hap.*Y_pos_mat, 2);
                prot_neg_hap=sum(im_mat_neg_hap.*Y_neg_mat, 2);
                
                CI_mat_neut(:,perm_k)=prot_pos_neut-prot_neg_neut;
                CI_mat_happ(:,perm_k)=prot_pos_hap-prot_neg_hap;
                
        
            end
           
            CI_happ(:,dim_k,ROI_k)=CI_mat_happ(:,1);
            CI_neut(:,dim_k,ROI_k)=CI_mat_neut(:,1);
            pval_CI_neut_mat(:, dim_k,ROI_k)=comp_pval(CI_mat_neut);
            pval_CI_hap_mat(:, dim_k,ROI_k)=comp_pval(CI_mat_happ);
            
            % to measure time
            display(['dimension ' num2str(dim_k)])
            toc

        end
        
        
        
        toc
    end
    
    p_happ=squeeze(single(pval_CI_hap_mat));
    p_neut=squeeze(single(pval_CI_neut_mat));
    CI_happ=squeeze(CI_happ);
    CI_neut=squeeze(CI_neut);
else % for leave one out analysis
    
    
    Y_mat=zscore(loadings);
    
    for ROI_k=1:size(loadings,4);
        
        pval_CI_neut_mat=NaN(sz, size(loadings,2), size(loadings,1));
        pval_CI_hap_mat=NaN(sz, size(loadings,2), size(loadings,1));
        
        for ind_k=1:size(loadings,3)
            rng('shuffle')
            Y_L1out=Y_mat(:,:,ind_k);
            if size(loadings,1)==size(loadings,3)
                imgs=im_mat;
            else
                indTrainHapp=1:size(loadings,1)-1;
                indTrainNeut=[1:size(loadings,1)-1]+size(im_mat,2)/2;
                indTestHapp=size(loadings,1)-1+ind_k;
                indTestNeut=size(loadings,1)-1+ind_k+size(im_mat,2)/2;
                imgs=im_mat(:,[indTrainHapp indTestHapp indTrainNeut indTestNeut]);
            end
            for dim_k=1:size(loadings,2);
                CI_mat_neut=NaN(sz, perm_n);
                CI_mat_happ=CI_mat_neut;
                parfor perm_k=1:perm_n+1
                    if perm_k>1
                        ind_rand=randperm(size(loadings,1))';
                        Y_rnd=Y_L1out(ind_rand,dim_k);
                    else
                        Y_rnd=Y_L1out(:,dim_k);
                    end
                    
                    ind_pos=find(Y_rnd(:,1)>0);
                    ind_neg=find(Y_rnd(:,1)<0);
                    
                    im_mat_pos_neut=imgs(:, ind_pos+size(loadings,1));
                    im_mat_neg_neut=imgs(:, ind_neg+size(loadings,1));
                    im_mat_pos_hap=imgs(:, ind_pos);
                    im_mat_neg_hap=imgs(:, ind_neg);
                    
                    Y_pos=Y_rnd(ind_pos,1);
                    Y_neg=-Y_rnd(ind_neg,1);
                    
                    Y_pos_mat=repmat(Y_pos', [sz 1]);
                    Y_neg_mat=repmat(Y_neg', [sz 1]);
                    
                    %%%prots - unscaled here
                    prot_pos_neut=sum(im_mat_pos_neut.*Y_pos_mat, 2);
                    prot_neg_neut=sum(im_mat_neg_neut.*Y_neg_mat, 2);
                    prot_pos_hap=sum(im_mat_pos_hap.*Y_pos_mat, 2);
                    prot_neg_hap=sum(im_mat_neg_hap.*Y_neg_mat, 2);
                   
                    CI_mat_neut(:,perm_k)=prot_pos_neut-prot_neg_neut;
                    CI_mat_happ(:,perm_k)=prot_pos_hap-prot_neg_hap;
                    
                    
                end
                
                pval_vect_neut=comp_pval(CI_mat_neut);
                pval_vect_hap=comp_pval(CI_mat_happ);
                pval_CI_neut_mat(:, dim_k, ind_k,ROI_k)=pval_vect_neut;
                pval_CI_hap_mat(:, dim_k, ind_k,ROI_k)=pval_vect_hap;
                
            end
            toc
            display(['identity ' num2str(ind_k)])
        end
        p_happ=squeeze(single(pval_CI_hap_mat));
        p_neut=squeeze(single(pval_CI_neut_mat)); 
    end
    toc
end
% close(h)

end




%% computes signif based on permutation test
function pval_vect=comp_pval(CI_mat)
sz=size(CI_mat,1);
perm_n=size(CI_mat,2);
tmp_sort=sort(abs(CI_mat), 2, 'descend');
tmp_act=abs(CI_mat(:,1));
rnk_vect=NaN(sz,1);
for val_k=1:sz
    rnk_vect(val_k, 1)=find(tmp_act(val_k,1)==tmp_sort(val_k,:), 1, 'last');
end
pval_vect=rnk_vect/perm_n;
pval_vect=pval_vect/2;%%1-tailed
end

