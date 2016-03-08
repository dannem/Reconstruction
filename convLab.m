function [labout]=convLab(imCellIn,test);
%This function converts cell array with images from RGB to LAB 
%imCellIn has to be a cell with size that equals the number of stimuli
%test - whether the force and back conversion is needed. 1 - needed, zero -
%not needed/
% Functions is written by DN. Based on MDS_neur_patt_v2

if nargin < 1;
    error(message('Not enough input'));
elseif nargin<2;
    test=0;
end
l=size(imCellIn);
for i=1:l(1)
    a=double(imCellIn{i});
    labout{i}=rgb2lab(a);
end
labout=labout';

if test
    rgb=[];
    lab=[];
    lab2=[];
    for i=1:l(1)
        rgb=cat(4,rgb,imCellIn{i});
        lab=cat(4,lab,labout{i});
        lab2=cat(4,lab2,lab2rgb(labout{i}));
        
    end
    rgbMean=uint8(mean(rgb,4));
    labMean=uint8(lab2rgb(mean(lab,4)));
    lab2Mean=uint8(mean(lab2,4));
    labDiff=labMean-rgbMean;
    lab2Diff=lab2Mean-rgbMean;
    imtool(rgbMean)
    imtool(labMean)
    imtool(lab2Mean)
    figure 
    hist(double(labDiff))
    title('Subtraction of converted average from the average RGB')
    figure 
    hist(double(lab2Diff))
    title('Subtraction of averaged individually converted files from the average RGB')
else
    display('No test was requested')
end
        