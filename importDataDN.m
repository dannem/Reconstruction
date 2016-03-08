function [outputVal outputCount]=importDataDN(mat,flip);
maxVal=max(mat(:,2));
outputVal=zeros(maxVal);
outputCount=zeros(maxVal);
for i=2:size(mat,1);
    if mat(i,1)==3
    else
    outputCount(mat(i,2),mat(i-1,2))= outputCount(mat(i,2),mat(i-1,2))+1;
    outputVal(mat(i,2),mat(i-1,2))=sum([mat(i,3); outputVal(mat(i,2),mat(i-1,2))]);
    end
end
if flip
outputVal=outputVal+outputVal';
outputCount=outputCount+outputCount';
end
outputVal=outputVal./outputCount;
% a=outputCount+outputCount'; 

