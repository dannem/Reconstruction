%%Visualization of reconstruction data
% change here your data structure
data=recon_output_all_13_within_60id_4els_1bin_tb_138_happ;
%% visualization of significant pixels for single permutation test
[pIdsN,~]=disp_CIs(data.CI_neut,data.p_neutAll,data.q,data.minNumPix,data.bck,data.ims,'Neutral');
[pIdsH,~]=disp_CIs(data.CI_happy,data.p_happAll,data.q,data.minNumPix,data.bck,data.ims,'Happy');
%% visualizatio of significant dimensions based on permutations
fig=figure;
set(fig, 'Position', [100, 100, 800, 695]);
for i=1:3
subplot(2,3,i)
imagesc(squeeze(data.outMatGen_neut(:,:,i)));
title(['Neutral channel ' num2str(i)]);
subplot(2,3,i+3)
imagesc(squeeze(data.outMatGen_happ(:,:,i)));
title(['Happy channel ' num2str(i)]);
end
%% showing faces
imageN=[1 2];
numIm=length(imageN)
fig=figure;
for i=1:numIm
recon_mat_sq_rgb = lab2rgb(data.recon_mat_sq(:,:,:,imageN(i)));
set(fig, 'Position', [100, 100, 800, 500]);
subplot(numIm,2,1+(i-1)*2)
imagesc(uint8(squeeze(recon_mat_sq_rgb)));
title(['Reconstructed identity number ' num2str(imageN(i))])
subplot(numIm,2,2+(i-1)*2)
imagesc(data.ims{imageN(i)});
title(['Original identity number ' num2str(imageN(i))])
end

%% plotting hitmaps of the test
% shows percetage of accurate descrimination (same pairs vs different
% pairs) in at each pixel.
lims=[0.1 0.8];
jet1=jet; jet1(1,:)=[0 0 0];
imNum=data.imNum;
[out_neut_L]=heat_map_recon(data.recon_mat_sq(:,:,:,imNum+1:imNum*2),data.labout(imNum+1:imNum*2),1);
[out_neut_A]=heat_map_recon(data.recon_mat_sq(:,:,:,imNum+1:imNum*2),data.labout(imNum+1:imNum*2),2);
[out_neut_B]=heat_map_recon(data.recon_mat_sq(:,:,:,imNum+1:imNum*2),data.labout(imNum+1:imNum*2),3);
[out_happ_L]=heat_map_recon(data.recon_mat_sq(:,:,:,1:imNum),data.labout(1:imNum),1);
[out_happ_A]=heat_map_recon(data.recon_mat_sq(:,:,:,1:imNum),data.labout(1:imNum),2);
[out_happ_B]=heat_map_recon(data.recon_mat_sq(:,:,:,1:imNum),data.labout(1:imNum),3);
plot_heatmap(out_neut_L,lims,jet1)
plot_heatmap(out_neut_A,lims,jet1)
plot_heatmap(out_neut_B,lims,jet1)
plot_heatmap(out_happ_L,lims,jet1)
plot_heatmap(out_happ_A,lims,jet1)
plot_heatmap(out_happ_B,lims,jet1)
