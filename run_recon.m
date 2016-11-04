for i=1:13
    load(namesfile(i+3).name);
    data=output_same_uw([60:62 64],:,:,78:385);
    tp=size(data,4);
    data= permute(data,[4 1 2 3]);
    data=reshape(data,tp*4,120,16);
    data=normOneRange(data);
    % data=reshape(data,tp,20,120,16);
    % data= permute(data,[2 3 4 1]);
    id_num=60;
    load('/Users/dannem/Desktop/EEG_preprocessed_data/ims_mixed.mat')
    name=['/Users/dannem/Desktop/EEG_preprocessed_data/'];
    bck=ell(:);
    bck=find(bck==0);
    c=1;
    [output_disc_within,~] = runSVM_same_emot(data(:,:,:),id_num,c);
    % confusibility matrix
    conf_happ_all_features_all_ids = squareform(squeeze(output_disc_within.ap(1,1,:)));
    conf_neut_all_features_all_ids = squareform(squeeze(output_disc_within.ap(1,2,:)));
    % reconstruction
    subjNum=['cum_all_13_within_60id_4els_' namesfile(i+3).name(5:8) '_happ'];
    pipeline_short(bck,conf_happ_all_features_all_ids,ims,name,subjNum,20,1000,20,0.1);
    subjNum=['cum_all_13_within_60id_4els_' namesfile(i+3).name(5:8) '_neut'];
    pipeline_short(bck,conf_happ_all_features_all_ids,ims,name,subjNum,20,1000,20,0.1);
    toc
end