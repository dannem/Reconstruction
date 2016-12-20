function data=pipeline_short(bck,conf,ims,saveFileDir,subNum,maxDim,permutN,minNumPix,q,conf2)

%% PIPELINE
%This pipeline is for reconstructing faces 
try
    %% Inputs
    if nargin<10
        no2conf=0;
    else
        no2conf=1;
        data.conf2=conf2;
    end
    tic
    data.subNum=subNum; % participant number
    data.maxDim=maxDim; % number of MDS to retain
    data.permutN=permutN; % number of permuations to perfrom
    data.minNumPix=minNumPix; % minimum number of pixels to include as a signficiant dimension
    data.q=q; % criterion (Q) for the FDR correction
    data.bck=bck;
    data.conf=conf;
    data.ims=ims;
    clear subNum maxDIm premutN minNumPix q bck conf ims
    %% Defining working directory and loading files
    data.saveFileDir=saveFileDir;
    mkdir(data.saveFileDir);
    clear saveFileDir
    
    %% arranging confusibility matrix from the output
    data.imNum = size(data.conf,1);
    
    %% Converting files to LAB space
    % Optional: Testing rgb to LAB conversion and back (set test to 1)
    [data.labout]=convLab(data.ims,0); %converting to LAB space. 0-no testing
    
    %% Computing MDS
    % computes visualization all identity included matrix loadings60 (ids X MDS dims)
    % and leave-one-out matrix fr permuations loadings59 (ids X ids X MDS dims)
    % Important: loadings59 contains a procurstian alignment weights for each identity N
    % at n X MDS_dims X n
    if no2conf
        [data.loadAll,data.loadLeaveOut,data.eigs,data.perc_expl,data.cum_exp]=patMDSsameEmot(data.conf,data.conf2,data.maxDim,0.0001);
    else
        [data.loadAll,data.loadLeaveOut,data.eigs,data.perc_expl,data.cum_exp]=patMDS(data.conf,data.maxDim,0.0001);
    end
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
 
    [data.p_happAll,data.p_neutAll,data.CI_happy,data.CI_neut]=ImClass(data.labout,data.loadAll,data.permutN,data.bck,0);
    %% FDR corrected iterations with leave-one-out
    
    [data.p_happLO,data.p_neutLO,~,~]=ImClass(data.labout,data.loadLeaveOut,data.permutN,data.bck,1);
    [data.outMatFDR_happ,data.outMatGen_happ] = FDR_CI_sel(data.p_happLO,data.q,data.minNumPix);
    [data.outMatFDR_neut,data.outMatGen_neut] = FDR_CI_sel(data.p_neutLO,data.q,data.minNumPix);
    
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
    [data.recon_mat]=face_reconst(data.outMatGen_neut,data.outMatGen_happ,data.loadLeaveOut,data.labout);
    
    %% arranging back into row x column X color X dim array
    data.recon_mat_sq=reshape(data.recon_mat,size(data.ims{1},1),size(data.ims{1},2),size(data.ims{1},3),size(data.ims,1));
    
    %% converting reconstructed faces into RGB
    for i=1:size(data.recon_mat_sq,4)
        data.recon_mat_sq_rgb(:,:,:,i) = uint8(Lab2RGB(data.recon_mat_sq(:,:,:,i)));
    end
    
catch ME
    data.errorMes=ME;    
end
data.outFile=[data.saveFileDir '/Recon_final_' data.subNum '_' date];
data.varName=['recon_output_' data.subNum];
eval([data.varName '=data;']);
data.scriptName = mfilename('fullpath');
data.duration=toc-tic;
save(data.outFile,data.varName);
