function [maskMat]=obj_test_pix(L_chan_heat,A_chan_heat,B_chan_heat,percentPix,bck,numch)
if numch==3
    avMat=cat(3,squeeze(mean(L_chan_heat,1)),squeeze(mean(A_chan_heat,1)),squeeze(mean(B_chan_heat,1)));
else
    avMat=mean(L_chan_heat,1);
end
avVec=avMat(:);
avVec(bck(1:length(bck)/3))=[];
critVal = prctile(avVec,percentPix);
maskMat=avMat>critVal;
maskMat=squeeze(maskMat);


    
        
    
