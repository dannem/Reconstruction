function pipeline_cluster
%% PIPELINE
%This pipeline is for reconstructing faces based on 2AFC behavioral task

%% Cleaning working space

% sca

%% Inputs
subNum=80; % participant number
maxDim=20; % number of MDS to retain
permutN=10000; % number of permuations to perfrom
minNumPix=10; % minimum number of pixels to include as a signficiant dimension
q=0.1; % criterion (Q) for the FDR correction
%% Defining working directory and loading files
% define working and directory to save files directory, 
% load output file and ims (images)
saveFileDir=['Documents/Reconstruction/Behavioral_Reconstruction/IO-2/'];
mkdir(saveFileDir);
load(['Dropbox/CompNeuroLab/EEG Reconstruction/Recon_Percept_Exp/Stimuli/ims.mat']);


%% arranging confusibility matrix from the output
imNum=size(conf,1);

%% Converting files to LAB space
% Optional: Testing rgb to LAB conversion and back (set test to 1)
[labout]=convLab(ims,0); %converting to LAB space. 0-no testing

%% Computing MDS
% computes visualization all identity included matrix loadings60 (ids X MDS dims) 
% and leave-one-out matrix fr permuations loadings59 (ids X ids X MDS dims) 
% Important: loadings59 contains a procurstian alignment weights for each identity N
% at n X MDS_dims X n
[loadAll,loadLeaveOut,eigs,perc_expl,cum_exp]=patMDS(conf,maxDim,0.0001);

%% visualization of prototypes
% protoPresent(loadAll,ims,[1 2 3],1);

%% Computing prototypes for visualization purposes
% Computing classification image based on LAB-converted stimuli and z-scored loadings
% Function ImClass first checks the dimensionality of the loading matrix.
% First it converts loadings to z scores.
% If the dimension number of the loading matrix is 2 it performs one 
% permutation test based on permutN number. Practically, for each pixel all
% permutation results are ranked and a percentile of a pixel value based on 
% the correct loading matrix is evaluted in a one-tailed manner.
% If the dimension number is 3 it itireates through all identities 
% and computes ranking similarly to described above. The output is p values
% matrices, classification images. bck is a vector containing background
% pixels and their position. 

run=1;
if run
    [p_happ60,p_neut60,CI_happy,CI_neut,bck]=ImClass(labout,loadAll,permutN,0);
    outFile=[saveFileDir '/pval_60_' num2str(subNum) '_' date];
    save(outFile,'p_happ60','p_neut60','CI_happy','CI_neut','bck','permutN');
else
    load('/Users/dannemrodov/Documents/Reconstruction/Behavioral_Reconstruction/final_10_18-Jan-2016')
end

%% visualization of significant pixels for single permutation test
vis=0;
if vis
    [pIdsN,~]=disp_CIs(CI_neut,p_neut60,q,minNumPix,bck,ims,'Neutral');
    [pIdsH,~]=disp_CIs(CI_happy,p_happ60,q,minNumPix,bck,ims,'Happy');
end
%% FDR corrected iterations with leave-one-out
run=0;
if run
    [p_happ59,p_neut59,~,~,bck]=ImClass(labout,loadLeaveOut,permutN,1);
    outFile=[saveFileDir num2str(subNum) '_' date];
    save(outFile,'p_happ59','p_neut59','bck','permutN');
else
    load('/Users/dannemrodov/Documents/Reconstruction/Behavioral_Reconstruction/final_10_18-Jan-2016')
end
[outMatFDR_happ,outMatGen_happ] = FDR_CI_sel(p_happ59,q,minNumPix);
[outMatFDR_neut,outMatGen_neut] = FDR_CI_sel(p_neut59,q,minNumPix);

%% vizualization of significant dimensions
vis=0;
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
    
%% chosing significant pixels for iterations
% In this part we perform following operations:
% 1.    Find significant dimensions based on permutations from ImClass.m
%       If no significant dimension is found the first dimension is used.
% 2.    Using sig dimension find distances of all training faces to origin.
% 3.    Norm all distances, so that sum of all distances is 1.
% 4.    Construct origin face.
% 5.    For each sig dim: Compute positive and negative averaged faces.
% 6.    For each sig dim: Compute CI by subtracting negative from positive.
% 7.    Multiply reconstruction by it's coordinates on the fitted face
%       space
% 8.    Divide CI by 2 to account for traversing the distance twice.
% 9.    Add origin  
% 10.    #5-9 are repeated for both emotions.
[recon_mat]=face_reconst(outMatGen_neut,outMatGen_happ,loadLeaveOut,labout);

%% arranging back into row x column X color X dim array
recon_mat_sq=reshape(recon_mat,size(ims{1},1),size(ims{1},2),size(ims{1},3),size(ims,1));

%% converting reconstructed faces into RGB
for i=1:size(recon_mat_sq,4)
    recon_mat_sq_rgb(:,:,:,i) = Lab2RGB(recon_mat_sq(:,:,:,i));
end

%% visualization of the image
% vis=1;
% imageN=29;
% if vis
%     fig=figure;
%     set(fig, 'Position', [100, 100, 800, 500]);
%     subplot(1,2,1)
%     imagesc(squeeze(recon_mat_sq_rgb(:,:,:,imageN)));
%     title(['Reconstructed identity number ' num2str(imageN)])
%     subplot(1,2,2)
%     imagesc(ims{imageN});
%     title(['Original identity number ' num2str(imageN)])
% end

%% running objective test 
% reconstructed image compared with pairs (original image and all different
% images) based on Euclidean distance. If the original image is closer a
% score of 1 is awarded, if further a score of 0 is awarded. Then all the
% scores are averaged per image, and the grand average of all reconstructed
% faces is compared against 0.5 using t-test.
[~,p_val_happL,aver_im_happL,aver_all_happL]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,2);
[~,p_val_happ,aver_im_happ,aver_all_happ]=obj_test(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),0.05,1);
[~,p_val_neutL,aver_im_neutL,aver_all_neutL]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,2);
[~,p_val_neut,aver_im_neut,aver_all_neut]=obj_test(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),0.05,1);

%% plotting hitmaps of the test
% shows percetage of accurate descrimination (same pairs vs different
% pairs) in at each pixel.
% lims=[0.1 0.8];
% jet1=jet; jet1(1,:)=[0 0 0];
% [out_neut_L]=heat_map_recon(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),1);
% [out_neut_A]=heat_map_recon(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),2);
% [out_neut_B]=heat_map_recon(recon_mat_sq(:,:,:,imNum+1:imNum*2),labout(imNum+1:imNum*2),3);
% [out_happ_L]=heat_map_recon(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),1);
% [out_happ_A]=heat_map_recon(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),2);
% [out_happ_B]=heat_map_recon(recon_mat_sq(:,:,:,1:imNum),labout(1:imNum),3);
% plot_heatmap(out_neut_L,lims,jet1)
% plot_heatmap(out_neut_A,lims,jet1)
% plot_heatmap(out_neut_B,lims,jet1)
% plot_heatmap(out_happ_L,lims,jet1)
% plot_heatmap(out_happ_A,lims,jet1)
% plot_heatmap(out_happ_B,lims,jet1)

outFile=[saveFileDir 'final_' num2str(subNum) '_' date];
save(outFile);