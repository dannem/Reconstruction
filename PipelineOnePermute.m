minNumPix=10; % minimum number of pixels to include as a signficiant dimension
q=0.1; % criterion (Q) for the FDR correction
[p_happ,p_neut]= ImClassOnePermut(ims_unf,conf_unf,1000,bck,20);
[~,outMatGen_happ] = FDR_CI_sel(p_happ,q,minNumPix);
[~,outMatGen_neut] = FDR_CI_sel(p_neut,q,minNumPix);

%%
[recon_mat_happ]=faceReconstOnePermute(outMatGen_happ,Y_proj,ims_unf(1:54));
[recon_mat_neut]=faceReconstOnePermute(outMatGen_happ,Y_proj,ims_unf(55:108));
%% arranging back into row x column X color X dim array
recon_mat_happ_sq=reshape(recon_mat_happ,size(ims_famous{1},1),size(ims_famous{1},2),size(ims_famous{1},3),size(ims_famous,1)/2);
recon_mat_neut_sq=reshape(recon_mat_neut,size(ims_famous{1},1),size(ims_famous{1},2),size(ims_famous{1},3),size(ims_famous,1)/2);
%% converting reconstructed faces into RGB
for i=1:size(recon_mat_neut_sq,4)
    recon_mat_happ_sq_rgb{i} = lab2rgb(recon_mat_happ_sq(:,:,:,i));
    recon_mat_neut_sq_rgb{i} = lab2rgb(recon_mat_neut_sq(:,:,:,i));
end

%% objective test
it=[26 46 28 8 29 32];
[~,p_val_happL,aver_im_happL,aver_all_happL]=objTestOnePermute(recon_mat_happ_sq(:,:,:,it),ims_famous(it),0.05,2);
[~,p_val_neutL,aver_im_neutL,aver_all_neutL]=objTestOnePermute(recon_mat_neut_sq(:,:,:,it),ims_famous(it+93),0.05,2);
[~,p_val_happ,aver_im_happ,aver_all_happ]=objTestOnePermute(recon_mat_happ_sq(:,:,:,it),ims_famous(it),0.05,1);
[~,p_val_neut,aver_im_neut,aver_all_neut]=objTestOnePermute(recon_mat_neut_sq(:,:,:,it),ims_famous(it+93),0.05,1);
% [~,p_val_happL,aver_im_happL,aver_all_happL]=objTestOnePermute(recon_mat_happ_sq,ims_famous(1:93),0.05,2);
% [~,p_val_neutL,aver_im_neutL,aver_all_neutL]=objTestOnePermute(recon_mat_neut_sq,ims_famous(94:186),0.05,2);
% [~,p_val_happ,aver_im_happ,aver_all_happ]=objTestOnePermute(recon_mat_happ_sq,ims_famous(1:93),0.05,1);
% [~,p_val_neut,aver_im_neut,aver_all_neut]=objTestOnePermute(recon_mat_neut_sq,ims_famous(94:186),0.05,1);
% [~,p_val_happL,aver_im_happL,aver_all_happL]=objTestOnePermute(recon_mat_happ_sq,ims_famous(1:93),ims_unf(1:54),0.05,2);
% [~,p_val_neutL,aver_im_neutL,aver_all_neutL]=objTestOnePermute(recon_mat_neut_sq,ims_famous(94:186),ims_unf(55:108),0.05,2);
% [~,p_val_happ,aver_im_happ,aver_all_happ]=objTestOnePermute(recon_mat_happ_sq,ims_famous(1:93),ims_unf(1:54),0.05,1);
% [~,p_val_neut,aver_im_neut,aver_all_neut]=objTestOnePermute(recon_mat_neut_sq,ims_famous(94:186),ims_unf(55:108),0.05,1);
%% plotting faces
for i=1:60;
    figure
%     subplot(2,2,1)
%     imshow(recon_mat_happ_sq_rgb{i})
%     subplot(2,2,2)
%     imshow(recon_mat_neut_sq_rgb{i})
    subplot(2,2,3)
    imshow(ims_mixed{i})
    subplot(2,2,4)
    imshow(ims_mixed{i+60})
%     suptitle([num2str(i) '  happy: ' num2str(aver_im_happ(i)) '  neutral: ' num2str(aver_im_neut(i))])
end
names=cell(120,1);
for i=1:120
    imwrite(ims{i},[names{i} '.tif']);
end