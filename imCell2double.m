function outIm=imCell2double(inIm,dims)
% if 2-dimensional matrix requested zeros (background values) are removed.
if dims==2
    ind=inIm{2};
    ind=find(ind);
    for i=1:length(inIm)
        temp=inIm{i};
        outIm(:,i)=temp(ind);
    end
elseif dims==4
    for i=1:length(inIm)
        outIm(:,:,:,i)=inIm{i};
    end
else
    error('Number of dimension must be either 2 or 4')
end