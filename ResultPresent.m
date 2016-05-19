%% visualization of prototypes without permutation (first 3 dimensions)
protoPresent(loadAll,ims(60:118),[1 2 3],1);

%% visualization of significant pixels for single permutation test
vis=1;
if vis
    [pIdsN,~]=disp_CIs(CI_neut,p_neutAll,q,minNumPix,bck,ims,'Neutral');
    [pIdsH,~]=disp_CIs(CI_happy,p_happAll,q,minNumPix,bck,ims,'Happy');
end

%% raster of significant dimensions
vis=1;
if vis
    fig=figure;
    set(fig, 'Position', [100, 100, 800, 695]);
    for i=1:3
    subplot(2,3,i)
    imagesc(squeeze(outMatGen_neut(:,:,i)));
    title(['Neutral channel ' num2str(i)]);
    subplot(2,3,i+3)
    imagesc(squeeze(outMatGen_happ(:,:,i)));
    title(['Happy channel ' num2str(i)]);
    end
end

% showing images
%% visualization of the image
for i=1:59
    imageN=i+59;
    fig=figure;
    set(fig, 'Position', [100, 100, 800, 500]);
    subplot(1,2,1)
    imagesc(squeeze(recon_mat_sq_rgb(:,:,:,imageN)));
    title(['Reconstructed id ' num2str(imageN) '. All channels acc: ' num2str(aver_im_neut(i))...
        '. L channel acc: ' num2str(aver_im_neutL(i))])
    subplot(1,2,2)
    imagesc(ims{imageN});
    title(['Original identity number ' num2str(i)])
end

%% plotting hitmaps of the test
% shows percetage of accurate descrimination (same pairs vs different
% pairs) in at each pixel.
lims=[0.3 0.6];
jet1=jet; jet1(1,:)=[0 0 0];
plot_heatmap(out_neut_L,lims,jet1)
plot_heatmap(out_neut_A,lims,jet1)
plot_heatmap(out_neut_B,lims,jet1)
plot_heatmap(out_happ_L,lims,jet1)
plot_heatmap(out_happ_A,lims,jet1)
plot_heatmap(out_happ_B,lims,jet1)