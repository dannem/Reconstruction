% loading data
% clear all
% load('/Users/dannem/Documents/Reconstruction/Recon results/Recon_final_cum_all_13_happy_within_4els_all_id_12-Oct-2016.mat')
% load('/Users/dannem/Documents/Reconstruction/Recon results/Recon_final_cum_all_13_neut_within_4els_all_id_12-Oct-2016.mat')
data=recon_output_all_all_13_within_60id_12els_307_bins_happ;
data1=recon_output_all_all_13_within_60id_12els_307_bins_neut;
fam=1;
if data.imNum==54
    ind1=55;
    ind2=108;
    fam=0;
elseif data.imNum==60
    ind1=61;
    ind2=114;
end
% famous: happy confusability
if fam==1
    [~,~,obj_fam_Lch_hap_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,55:60),data.labout(55:60),0.05,2);
    [~,~,obj_fam_all_hap_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,55:60),data.labout(55:60),0.05,1);
    [~,~,obj_fam_Lch_hap_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,115:120),data.labout(115:120),0.05,2);
    [~,~,obj_fam_all_hap_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,115:120),data.labout(115:120),0.05,1);
end
% unfamiliar: happy confusability

[~,~,obj_unf_Lch_hap_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,1:54),data.labout(1:54),0.05,2);
[~,~,obj_unf_all_hap_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,1:54),data.labout(1:54),0.05,1);
[~,~,obj_unf_Lch_hap_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,ind1:ind2),data.labout(ind1:ind2),0.05,2);
[~,~,obj_unf_all_hap_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,ind1:ind2),data.labout(ind1:ind2),0.05,1);

% load('/Users/dannem/Documents/Reconstruction/Recon results/all(12)/Recon_EEG_final_all_12_neutral_28-Sep-2016.mat')
data=data1;
% famous: neutral confusability
if fam==1
    [~,~,obj_fam_Lch_neut_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,55:60),data.labout(55:60),0.05,2);
    [~,~,obj_fam_all_neut_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,55:60),data.labout(55:60),0.05,1);
    [~,~,obj_fam_Lch_neut_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,115:120),data.labout(115:120),0.05,2);
    [~,~,obj_fam_all_neut_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,115:120),data.labout(115:120),0.05,1);
end
% unfamiliar: neutral confusability

[~,~,obj_unf_Lch_neut_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,1:54),data.labout(1:54),0.05,2);
[~,~,obj_unf_all_neut_to_happ,~]=obj_test(data.recon_mat_sq(:,:,:,1:54),data.labout(1:54),0.05,1);
[~,~,obj_unf_Lch_neut_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,ind1:ind2),data.labout(ind1:ind2),0.05,2);
[~,~,obj_unf_all_neut_to_neut,~]=obj_test(data.recon_mat_sq(:,:,:,ind1:ind2),data.labout(ind1:ind2),0.05,1);

if fam==1
    obj_EEG_fam=table(obj_fam_all_hap_to_happ, obj_fam_all_hap_to_neut,...
        obj_fam_all_neut_to_happ, obj_fam_all_neut_to_neut,...
        obj_fam_Lch_hap_to_happ, obj_fam_Lch_hap_to_neut,...
        obj_fam_Lch_neut_to_happ, obj_fam_Lch_neut_to_neut);
end
obj_EEG_unf=table(obj_unf_all_hap_to_happ, obj_unf_all_hap_to_neut,...
    obj_unf_all_neut_to_happ, obj_unf_all_neut_to_neut,...
    obj_unf_Lch_hap_to_happ, obj_unf_Lch_hap_to_neut,...
    obj_unf_Lch_neut_to_happ, obj_unf_Lch_neut_to_neut);

func = @mean;
mean_unf=varfun(func,obj_EEG_unf)
if fam==1
    mean_fam=varfun(func,obj_EEG_fam)
end
std(obj_unf_all_neut_to_happ)/sqrt(54)
std(obj_unf_all_hap_to_neut)/sqrt(54)
std(obj_unf_all_hap_to_happ)/sqrt(54)
std(obj_unf_all_neut_to_neut)/sqrt(54)
[a b]=ttest(obj_unf_all_neut_to_neut,0.5)
[a b]=ttest(obj_unf_all_hap_to_neut,0.5)
[a b]=ttest(obj_unf_all_neut_to_happ,0.5)
[a b]=ttest(obj_unf_all_neut_to_neut,0.5)