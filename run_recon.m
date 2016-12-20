% for i=1:13
%     load(namesfile(i).name);
    data=output_same_uw([22:27 59:64],:,:,78:78+306);
    tp=size(data,4);
    els=size(data,1);
    data= permute(data,[4 1 2 3]);
    data=reshape(data,tp*els,120,16);
    data=normOneRange(data);
    % data=reshape(data,tp,20,120,16);
    % data= permute(data,[2 3 4 1]);
    id_num=60;
    load('/Users/dannem/Documents/Reconstruction/Processed files/for_recon/ims_mixed.mat')
    name=['/Users/dannem/Desktop/untitled folder/'];
    bck=ell(:);
    bck=find(bck==0);
    c=1;
    [output_disc_within,~] = runSVM_same_emot(data(:,:,:),id_num,c);
    % confusibility matrix
    conf_happ_all_features_all_ids = squareform(squeeze(output_disc_within.ap(1,1,:)));
    conf_neut_all_features_all_ids = squareform(squeeze(output_disc_within.ap(1,2,:)));
    % reconstruction
    subjNum=['cum_all_13_within_60id_4els_happ'];
    pipeline_short(bck,conf_happ_all_features_all_ids,ims,name,subjNum,20,1000,20,0.1,conf_neut_all_features_all_ids);
    subjNum=['cum_all_13_within_60id_4els_neut'];
    pipeline_short(bck,conf_neut_all_features_all_ids,ims,name,subjNum,20,1000,20,0.1,conf_happ_all_features_all_ids);
    toc
% end