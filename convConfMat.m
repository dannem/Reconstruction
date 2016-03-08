function out=convConfMat(discMat,combos,bin)
%% this funciton takes matrix of d or accuracy and converts it to confusability
% discMat - outAcc.ap or outAcc.d
% combos -  matrix with permutations
% bin    -  time bin of discrimination
if length(discMat)~=length(combos)
    error('matrices do not match')
end
temp=discMat(:,:,bin);
temp=squeeze(mean(temp,1));
out=NaN(max(combos(:)));
for i=1:size(combos,1)
    out(combos(i,1),combos(i,2))=temp(i);
    out(combos(i,2),combos(i,1))=temp(i);
end
out(logical(eye(size(out)))) = 0;