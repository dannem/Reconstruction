% objective test by heat maps
rangeEmo=[60:118];
for i=100:-1:1
    maskMat=obj_test_pix(heat_neut_L,heat_neut_A,heat_neut_B,i,bck,1);
    maskMat=repmat(maskMat,1,1,3,imNum);
    reconTemp=recon_mat_sq(:,:,:,rangeEmo);
    reconTemp(~maskMat)=0;
    imsTemp=labout(rangeEmo);
    for j=1:size(imsTemp,1)
        temp=imsTemp{j};
        temp(~squeeze(maskMat(:,:,:,1)))=0;
        imsTemp{j}=temp;
    end
    [~,p_val_happ,aver_im_happ,acc_aver]=obj_test(reconTemp,imsTemp,0.05,2);
    accValue(i)=acc_aver;
end

%% correlation
happ_famous_heat=cat(3,squeeze(mean(out_happ_L,1)),squeeze(mean(out_happ_A,1)),squeeze(mean(out_happ_B,1)));
neut_famous_heat=cat(3,squeeze(mean(out_neut_L,1)),squeeze(mean(out_neut_A,1)),squeeze(mean(out_neut_B,1)));
happ_unfamil_heat=cat(3,squeeze(mean(heat_happ_L,1)),squeeze(mean(heat_happ_A,1)),squeeze(mean(heat_happ_B,1)));
neut_unfamil_heat=cat(3,squeeze(mean(heat_neut_L,1)),squeeze(mean(heat_neut_A,1)),squeeze(mean(heat_neut_B,1)));

happ_famous_heat=happ_famous_heat(:);
neut_famous_heat=neut_famous_heat(:);
happ_unfamil_heat=happ_unfamil_heat(:);
neut_unfamil_heat=neut_unfamil_heat(:);

happ_famous_heat=happ_famous_heat(setdiff(1:max(bck),bck));
neut_famous_heat=neut_famous_heat(setdiff(1:max(bck),bck));
happ_unfamil_heat=happ_unfamil_heat(setdiff(1:max(bck),bck));
neut_unfamil_heat=neut_unfamil_heat(setdiff(1:max(bck),bck));