function matOut=normOneRange(matIn)
%% converts columns of the input matrix to zscored
% 0-1 range with average of 0.5
matOut=zscore(matIn);
matOut=matOut./repmat(max(abs(matOut)),size(matOut,1),1);
matOut=(matOut+1)/2;