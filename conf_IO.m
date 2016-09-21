function conf=conf_IO(ims,type)
%% This function computes confusibility matrix for images for Ideal Observer analysis
% Input:    ims -   cell with all the images
%           type -  across(default) or within. Across assumes that the array
%                   consists of two emotions ordered from 1:n/2 and n/2+1:n
%                   type 1 - across; type 2 - within
% Output:   conf -  confusibility matrix
if nargin<2
    type=1;
else
end

if type==1
    maxVal=length(ims)/2;
    vecInd=nchoosek(1:maxVal,2);
    outputVal=zeros(maxVal);
    for i=1:length(vecInd)
        a1=double(ims{vecInd(i,1)}(:));
        a2=double(ims{vecInd(i,1)+maxVal}(:));
        b1=double(ims{vecInd(i,2)}(:));
        b2=double(ims{vecInd(i,2)+maxVal}(:));
        
        a=[a1;a2];
        b=[b2;b1];
        
        outputVal(vecInd(i,1),vecInd(i,2))=sqrt(sum((a-b).^2));
        outputVal(vecInd(i,2),vecInd(i,1))=sqrt(sum((a-b).^2));
        
    end
else
    maxVal=length(ims);
    vecInd=nchoosek(1:maxVal,2);
    outputVal=zeros(maxVal);
    for i=1:length(vecInd)
        a=double(ims{vecInd(i,1)}(:));
        b=double(ims{vecInd(i,2)}(:));
        outputVal(vecInd(i,1),vecInd(i,2))=sqrt(sum((a-b).^2));
        outputVal(vecInd(i,2),vecInd(i,1))=sqrt(sum((a-b).^2));
        
    end
end
conf=outputVal;
conf=conf./max(max(conf));% to make them from 0 to 1;
% conf(logical(eye(size(conf))))=0;
