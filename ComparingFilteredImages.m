for i=1:118
    ims_filt_64{i}=squeeze(output_orig(4,i,:,:,:));
end
ims_filt_64=ims_filt_64';

rec=permute(squeeze(output_recon(4,:,:,:,:)),[2,3,4,1]);
orig=ims_filt_64;

[~,p_val_happL,aver_im_happL,aver_all_happL]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,2);
[~,p_val_happ,aver_im_happ,aver_all_happ]=obj_test(rec(:,:,:,1:imNum),orig(1:imNum),0.05,1);
[~,p_val_neutL,aver_im_neutL,aver_all_neutL]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,2);
[~,p_val_neut,aver_im_neut,aver_all_neut]=obj_test(rec(:,:,:,imNum+1:imNum*2),orig(imNum+1:imNum*2),0.05,1);