
function [outMatFDR,outMatGen] = FDR_CI_sel(mat,q,minNumPix)
dim_max=size(mat,2);
outMatPix=NaN(size(mat));
chanSize=size(mat,1)/3;
if ndims(mat)==3
    sel_res_FDR_bin=NaN(size(mat,3),dim_max,3);
    for ind_k=1:size(mat,3)
        for dim_k=1:dim_max
            for j=1:3
                rangChan=(j-1)*chanSize+1:j*chanSize;
                [pID,~,~,~] = FDR_comp(squeeze(mat(rangChan,dim_k, ind_k)), q);
                if size(pID)>0
                    temp=zeros(size(rangChan));
                    temp=mat(rangChan,dim_k, ind_k)<pID==1;
                    sel_res_FDR_bin(ind_k, dim_k,j)=1;
                    if sum(temp)<minNumPix
                        sel_res_FDR_bin(ind_k, dim_k,j)=0;
                        outMatPix(rangChan+(length(rangChan)*(j-1)),dim_k, ind_k)=0;
                    else
                        outMatPix(rangChan+(length(rangChan)*(j-1)),dim_k, ind_k)=temp;
                    end
                else
                    sel_res_FDR_bin(ind_k, dim_k,j)=0;
                end
            end
        end 
    end
end
outMatFDR=outMatPix;
outMatGen=sel_res_FDR_bin;
end

