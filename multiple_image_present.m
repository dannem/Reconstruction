close all
for i=1:120
    figure
    subplot(1,2,1)
    imagesc(ims{i})
    subplot(1,2,2)
    imagesc(recon_mat_sq_rgb(:,:,:,i))
    if i<61
        suptitle(num2str(i))
    else
        suptitle(num2str(i-60))
    end
end
    