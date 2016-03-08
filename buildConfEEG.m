% aggregating discrimination into confusability matrix
%% this function transforms a discrimintion matrix (acc) into an array with 
% confusability matrices per time bin
% Inputs: 
% 1.    Discrimination output from SVM funciton (acc cell)
% 2.    combos matrix showing combinations of pairs.
% Output:
% 1.    an array with series of confusability matrices per time bin, 
%       normalized between 0 and 1, with 0 in the diagonal.
% 2.    an array with number of counts for check.

function [outMatVal,outMatCount]=buildConfEEG(matIn,combos)
outMatVal=NaN(max(combos(:)),max(combos(:)),size(matIn,3));
outMatCount=zeros(max(combos(:)),max(combos(:)),size(matIn,3));
for i=1:size(matIn,3)
    for j=1:size(matIn,2)
        outMatVal(combos(j,1),combos(j,2),i)=mean(matIn(:,j,i),1);
        outMatCount(combos(j,1),combos(j,2),i)=outMatCount(combos(j,1),combos(j,2),i)+1;
        outMatVal(combos(j,2),combos(j,1),i)=mean(matIn(:,j,i),1);
        outMatCount(combos(j,2),combos(j,1),i)=outMatCount(combos(j,2),combos(j,1),i)+1;
    end
    temp=squeeze(outMatVal(:,:,i));
    temp=(temp-min(temp(:)))/(max(temp(:))-min(temp(:)));
    temp(1:max(combos(:))+1:max(combos(:))*max(combos(:))) = 0;
    outMatVal(:,:,i)=temp;
end
