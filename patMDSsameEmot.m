function [compY,leaveOutY,eigs,perc_expl,perc_expl_cum]=patMDSsameEmot(confMatIn,confMatIn2,ndims,dimMDScrit,typeData)
% This function takes a square confusibility matrix and computes MDS
% soloution
%Arguments: confMatIn - square confusibility matrix
%           ndims -     number of dims saved (optional)
%           dimMDScrit - eigenvalue criterion for inclusion
%           typeData -  cell array with the stimuli. If provided
%                       the plots will be presented.
%                       If the matrix of stimuli numbers provided, only
%                       names will be presentd. 
%Output:    compY -     loadings of the entire matrix MDS...
%           leaveOutY - loadings with leave-out procedure: ids x ids xdims...
%                       in each Mat(n,n) position - Procrustian alignment of 59 to 60
%                       face space for identity n. Dimensions: ids x MDS dims x ids
%           eigs -      eigentvectors above dimMDScrit
%           perc_expl - % explained variance
%           perc_expl_cum - cumulatvie % explained variance
% Functions is written by DN. Based on MDS_neur_patt_v2

%% Checks
if nargin<1
    error(message('Not enough input'));
elseif nargin<5
    plot_on=0;  
    display('No plot will be plotted')
else
    plot_on=1;
end

if size(confMatIn,1)~=size(confMatIn,2)
    error(message('A square confusability matrix must be provdied'));
elseif size(size(confMatIn))>2
    error(message('A square confusability matrix must be provdied'));
else
end

%% preparing matlab
n=size(confMatIn,1);
confMatIn(1:n+1:n*n) = 0; % putting 0 in main diagonal. 
confMatIn=confMatIn - min(confMatIn(:));% making sure that all values are positive
confMatIn2(1:n+1:n*n) = 0; % putting 0 in main diagonal. 
confMatIn2=confMatIn2 - min(confMatIn2(:));
%% computing a single all-included MDS solution
[Y,eigs] = cmdscale(confMatIn);
[Y2,eigs2] = cmdscale(confMatIn2);
%% determine the number of dimensions to preserve
if nargin<2
    dim_max = length(eigs);
elseif nargin<3
    dim_max = ndims;
else
    dim_max = sum(eigs>dimMDScrit); %nmb of pos dims
    dim_max = min(dim_max, ndims); % choosing wich dimension is bigger
end
compY=Y(:, 1:dim_max);% all included output
compY2=Y2(:, 1:dim_max);% all included output
%%%%check on perc explained var
eigs=eigs(1:dim_max,1);
perc_expl=eigs/sum(eigs);
perc_expl_cum=cumsum(eigs)/sum(eigs);
% perc_exp_summ_confMDS=[perc_expl perc_expl_cum];

%% computing leave-one-out
leaveOutY=NaN(n, dim_max, n);%60 L1out plus the original (all-in) MDS
for ind_k=1:n
    ind_train=setdiff(1:n, ind_k); %indices without "leave out" 
    conf_mat_sym_L1out=confMatIn(ind_train, ind_train);% matrix without leave out
    
    [Y_L1out,eigs_L1out] = cmdscale(conf_mat_sym_L1out);
    
    dim_max=min(length(eigs_L1out),dim_max);%make sure that the # dims is not more than actual dims
    
    Y_L1out=Y_L1out(:, 1:dim_max);
    [~,~,tf] = procrustes(Y_L1out,compY2(ind_train, 1:dim_max));
    Y_proj = tf.b*compY2(:, 1:dim_max)*tf.T + repmat(tf.c(1,:), n, 1);
    
    leaveOutY(ind_train, :, ind_k)=Y_L1out(:, 1:dim_max);
    leaveOutY(ind_k, :, ind_k)=Y_proj(ind_k, 1:dim_max);
    
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
    plot(compY(:,1),compY(:,2),'.', 'MarkerEdgeColor',col_vect,'MarkerFaceColor',col_vect, 'MarkerSize',21);
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