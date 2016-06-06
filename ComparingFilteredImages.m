for i=1:118
    ims_filt_08{i}=squeeze(output_orig(1,i,:,:,:));
end
ims_filt_08=ims_filt_08';

rec=permute(squeeze(output_recon(1,:,:,:,:)),[2,3,4,1]);
orig=ims_filt_08;
imNum=59;
[~,p_val_happL,aver_im_happL,aver_all_happ_a]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,3);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_a]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,3);
[~,p_val_happL,aver_im_happL,aver_all_happ_b]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,4);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_b]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,4);
[~,p_val_happL,aver_im_happL,aver_all_happ_la]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,5);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_la]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,5);
[~,p_val_happL,aver_im_happL,aver_all_happ_lb]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,6);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_lb]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,6);
[~,p_val_happL,aver_im_happL,aver_all_happ_ab]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,7);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_ab]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,7);

[~,p_val_happL,aver_im_happL,aver_all_happ_a]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,3);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_a]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,3);
[~,p_val_happL,aver_im_happL,aver_all_happ_b]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,4);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_b]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,4);
[~,p_val_happL,aver_im_happL,aver_all_happ_la]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,5);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_la]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,5);
[~,p_val_happL,aver_im_happL,aver_all_happ_lb]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,6);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_lb]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,6);
[~,p_val_happL,aver_im_happL,aver_all_happ_ab]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,7);
[~,p_val_neutL,aver_im_neutL,aver_all_neut_ab]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,7);
a=squeeze(output_orig(4,1,:,:,:));
imshow(lab2rgb(a))