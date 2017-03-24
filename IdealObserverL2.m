% ims_pca=ims2mat('/Users/dannem/Dropbox/CompNeuroLab/EEG Reconstruction/Stimuli/FamousFaces#5_PCA','tif');
% ims=ims2mat('/Users/dannem/Dropbox/CompNeuroLab/Unfamiliar_Faces','tif');
% ims=ims_unf;
maxVal=length(ims)/2;
vecInd=nchoosek(1:maxVal,2);
outputVal=zeros(maxVal);
for i=1:length(vecInd)
    a1=double(ims{vecInd(i,1)}(:));
    a2=double(ims{vecInd(i,1)+maxVal}(:));
    a=[a1;a2];
    a=a1;
    b1=double(ims{vecInd(i,2)}(:));
    b2=double(ims{vecInd(i,2)+maxVal}(:));
    b=[b2;b1];
    b=b1;
    outputVal(vecInd(i,1),vecInd(i,2))=sqrt(sum((a-b).^2));
    outputVal(vecInd(i,2),vecInd(i,1))=sqrt(sum((a-b).^2));
    
end
conf=outputVal;
conf=conf./max(max(conf));% to make them from 0 to 1;
clear outputVal vecInd b b1 b2 a a1 a2 maxVal