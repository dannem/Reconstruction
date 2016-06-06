function output=rankingPixels(dirIn,fileType,bck)
if iscellstr(dirIn)
    ims=readMultipleImages(dirIn,fileType,bck,'Format','double2D');
elseif iscell(dirIn)
    for i=1:size(dirIn,1)
        temp=dirIn{i};
        ims(:,i)=temp(setdiff(1:max(bck),bck));
    end 
    bck=bck(1:size(bck,1)/3);
    vec=ones(max(bck),1);
    vec(bck)=0;
    bck=reshape(vec,size(temp,1),size(temp,2));
else
    error
end
imNum=size(ims,2)/2;
for i=1:imNum
    tempH=ims(:,1:imNum);
    tempN=ims(:,imNum+1:size(ims,2));
    tempH(:,i)=[];
    tempN(:,i)=[];
    combos = nchoosek(1:size(tempH,2),2);
    for j=1:size(combos,1)
        outputH(:,j)=tempH(:,combos(j,1))-tempH(:,combos(j,2));
        outputN(:,j)=tempN(:,combos(j,1))-tempN(:,combos(j,2));
    end
    outputH=outputH.^2;
    outputN=outputH.^2;
    outputH=mean(outputH,2);
    outputN=mean(outputN,2);
    outputUp=(outputH+outputN)./2;
    
    outputDown=(tempH-tempN).^2;
    outputDown=mean(outputDown,2);
    
    temp=outputUp./outputDown;
    output{i}=rebuildImage(temp,bck);
end


function out_image=rebuildImage(vect,bck)
sz_im=size(bck);
vec_bck=bck(:);
vec_bck=[vec_bck;vec_bck;vec_bck];
out_image=zeros(prod([sz_im 3]),1);
vect=255*vect./max(vect);
out_image(logical(vec_bck))=vect;
out_image=uint8(reshape(out_image,[sz_im 3]));

