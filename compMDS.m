function [allMDS,leaveOutMDS,eigs,perc_expl,perc_expl_cum]=compMDS(confMatIn,indTrain,ndims,typeData)
% This function takes a square confusibility matrix and computes MDS
% soloution
%Arguments: confMatIn - square confusibility matrix with all identities
%           indTrain -   indices of training (if O - leave-out-for all)
%           ndims -     number of dims saved (optional)
%           typeData -  cell array with the stimuli. If provided
%                       the plots will be presented.
%                       If the matrix of stimuli numbers provided, only
%                       names will be presentd. 
%Output:    allMDS -     loadings of the entire matrix MDS...
%           leaveOutMDS - loadings with leave-out procedure: ids x ids xdims...
%                       in each Mat(n,n) position - Procrustian alignment of 59 to 60
%                       face space for identity n. Dimensions: ids x MDS dims x ids
%           eigs -      eigentvectors above dimMDScrit
%           perc_expl - % explained variance
%           perc_expl_cum - cumulatvie % explained variance
% Functions is written by DN. Based on MDS_neur_patt_v2

%% Checks
% checking number of arguments
if nargin<1
    error(message('Not enough input'));
elseif nargin<2
    indTrain=0;
    ndims=20;
    plot_on=0;  
    display('No plot will be plotted')
elseif nargin<3
    ndims=20;
    plot_on=0;  
    display('No plot will be plotted')
elseif nargin<4
    plot_on=0;
else
    plot_on=1;
end

%checking the confusability matrix and consistency of arguments
if size(confMatIn,1)~=size(confMatIn,2)
    error(message('A square confusability matrix must be provdied'));
elseif size(size(confMatIn))>2
    error(message('A square confusability matrix must be provdied'));
else
end

if size(confMatIn,1)<length(indTrain)
    error(message('The index of training images is too big'));
end
%% preparing matlab
n=size(confMatIn,1);
indTest=setdiff(1:n, indTrain);
confMatIn(1:n+1:n*n) = 0; % putting 0 in main diagonal. 
confMatIn=confMatIn - min(confMatIn(:));% making sure that all values are positive

%% computing a single all-included MDS solution
[allMDS,eigs] = cmdscale(confMatIn);

%% determine the number of dimensions to preserve
allMDS=allMDS(:, 1:ndims);% all included output

%%%%check on perc explained var
eigs=eigs(1:ndims,1);
perc_expl=eigs/sum(eigs);
perc_expl_cum=cumsum(eigs)/sum(eigs);
% perc_exp_summ_confMDS=[perc_expl perc_expl_cum];

%% computing leave-one-out
if indTrain==0 % computing MDS leave-one-out for all identities
    leaveOutMDS=NaN(n, ndims, n);%60 L1out plus the original (all-in) MDS
    for ind_k=1:n
        ind_train=setdiff(1:n, ind_k); %indices without "leave out"
        conf_mat_sym_L1out=confMatIn(ind_train, ind_train);% matrix without leave out
        [Y_L1out,eigs_L1out] = cmdscale(conf_mat_sym_L1out);
        ndims=min(length(eigs_L1out),ndims);%make sure that the # dims is not more than actual dims
        Y_L1out=Y_L1out(:, 1:ndims);
        [~,~,tf] = procrustes(Y_L1out,allMDS(ind_train, 1:ndims));
        Y_proj = tf.b*allMDS(:, 1:ndims)*tf.T + repmat(tf.c(1,:), n, 1);
        leaveOutMDS(ind_train, :, ind_k)=Y_L1out(:, 1:ndims);
        leaveOutMDS(ind_k, :, ind_k)=Y_proj(ind_k, 1:ndims);
    end
else
    leaveOutMDS=NaN(length(indTrain)+1, ndims, length(indTest));%60 L1out plus the original (all-in) MDS
    conf_mat_sym_L1out=confMatIn(indTrain, indTrain);% matrix without leave out
    [Y_L1out,eigs_L1out] = cmdscale(conf_mat_sym_L1out);
    ndims=min(length(eigs_L1out),ndims); %make sure that the # dims is not more than actual dims
    Y_L1out=Y_L1out(:, 1:ndims);
    for ind_k=1:length(indTest)
        withMDS=cmdscale(confMatIn([indTrain indTest(ind_k)],[indTrain indTest(ind_k)]));
        [~,~,tf] = procrustes(Y_L1out,withMDS(1:end-1,1:ndims));
        Y_proj = tf.b*withMDS(:,1:ndims)*tf.T + repmat(tf.c(1,:), size(withMDS,1), 1);
        leaveOutMDS(1:length(indTrain), :, ind_k)=Y_L1out(:,1:ndims);
        leaveOutMDS(length(indTrain)+1, :, ind_k)=Y_proj(end, 1:ndims);  
    end
end
%% plot MDS results
if plot_on
    
    %      if ROI_k==1
    %          Y(:,2)=-Y(:,2);%%%to free upper top (for fig inset) & get some match w/ bhv
    %      end
    
    figure
    
    xlabel('1st dimension');
    ylabel('2nd dimension');
    
    col_vect=[0.8 0 0];
    
    %%%choose to plot raw or zscored solution
    plot(allMDS(:,1),allMDS(:,2),'.', 'MarkerEdgeColor',col_vect,'MarkerFaceColor',col_vect, 'MarkerSize',21);
    %plot(zscore(Y(:,1)), zscore(Y(:,2)),'d', 'MarkerEdgeColor',[.6 .1 .1],'MarkerFaceColor',[.6 .1 .1], 'MarkerSize',5)
    
    box off
    
    %%%control (set) aspect ratio & size of plot in inches
    %%%(so reproducible in the future); and figure size (to enclose entire plot)
    
    set(gca, 'Units', 'inches');
    set(gca, 'Position', [0.5 0.5 10 8]);
    set(gca,'PlotBoxAspectRatio', [1.25 1 1]);
    
    set(gcf, 'Units', 'inches');
    set(gcf, 'Position', [2 2 11 9]);
    
    %%%choose axis limits appropriately
    %if ROI_k==0
    %%%bhv plot
    %          axis([-0.45 0.6 -0.6 0.45])
    %          set(gca,'XTick',-0.45:0.15:0.6)
    %          set(gca,'YTick',-0.6:0.15:0.45)
    %elseif ROI_k==1
    %%%rFG plot
    %          axis([-1 1 -1 1])
    %          set(gca,'XTick',-1:0.25:1)
    %          set(gca,'YTick',-1:0.25:1)
    %end
    
    %%%label points with 1-60
    %      nm_mat=1:60;
    if iscell(typeData)
        gimage(typeData)
    elseif typeData
        gname(typeData)
    else
        
    end
end