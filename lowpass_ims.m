function lowpass_ims


%dim_max=10;
use_col=1;
ROI_k=1;%90;

cond_col=1;
if cond_col
    cond_nm='col';
else cond_nm='gray';
end

cform_lab2srgb = makecform('lab2srgb');
cform_rgb2lab = makecform('srgb2lab');

% fold_fl=['../../design_stims/stims/exp_categ1_', cond_nm, '.mat'];
% load(fold_fl, 'im_mat')
load('/Users/dannem/Documents/Reconstruction/Analysis/Behavioral_Reconstruction/Ideal observer/idealObserver.mat');
for i=1:length(ims)
    a=ims{i};
    im_mat(:,i)=a(:);
end
[sz, im_n]=size(im_mat);
sz_comp=sz/3;

%%%get im size and mask ind (needed to reconstr ims of vects)
% [sz_im, ones_ind]=reverse_ellipse_mask;
sz_im=size(ims{1}); 
ones_ind=setdiff([1:bck(length(bck)/3)],bck)';

im_mat_hap=im_mat(:,1:59);
im_mat_neut=im_mat(:,60:118);

%recon_fold='recon_res/';
% recon_fold='recon_res_v2/';
% 
% recon_res_fl=[recon_fold, 'ROI',  sprintf('%02.0f', ROI_k), '_', cond_nm, '_dimselqp10', '_recon', '.txt'];
% recon_mat=dlmread(recon_res_fl);

recon_mat_neut=recon_mat(:,1:59);
recon_mat_hap=recon_mat(:,60:118);


for id_k=1:59 %idset
    
    %id_cnt=id_cnt+1;
    
    im_orig_neut=im_mat_neut(:, id_k);
    recon_im_neut=recon_mat_neut(:, id_k);
    
    im_orig_hap=im_mat_hap(:, id_k);
    recon_im_hap=recon_mat_hap(:, id_k);
    
    im_orig_neut_disp=conv_vect_to_im(im_orig_neut, sz_im, ones_ind, cform_rgb2lab);
    recon_im_neut_disp=conv_vect_to_im(recon_im_neut, sz_im, ones_ind, cform_rgb2lab);
    im_orig_hap_disp=conv_vect_to_im(im_orig_hap, sz_im, ones_ind, cform_rgb2lab);
    recon_im_hap_disp=conv_vect_to_im(recon_im_hap, sz_im, ones_ind, cform_rgb2lab);
    
    im_orig_neut_disp_RGB=applycform(im_orig_neut_disp,cform_lab2srgb);
    recon_im_neut_disp_RGB=applycform(recon_im_neut_disp,cform_lab2srgb);
     imtool(imresize(im_orig_neut_disp_RGB, 4, 'nearest'))
     imtool(imresize(recon_im_neut_disp_RGB, 4, 'nearest'))




%     figure
%     hold on
%     for cond=1:1
%         for k=1:2
%             if k==1
%                 F=fft2(im_orig_neut_disp(:,:, cond));
%             else F=fft2(recon_im_neut_disp(:,:, cond));
%             end
%         
%             F2=abs(F);
%             F2=fftshift(F2);
%             %figure,imshow(log(1+F2),[])
% 
%             [F2_x, F2_y]=size(F2);
%             F2_xhalf=round(F2_x/2); F2_yhalf=round(F2_y/2);
%             [Y, X]=meshgrid(-F2_yhalf+1:F2_y-F2_yhalf, -F2_xhalf+1:F2_x-F2_xhalf);
%             D_mat=sqrt(X.^2+Y.^2);
%                     H = exp(-(D_mat.^2)./(2*(64^2)));
%                     %imshow(H)
%                     
%                     F2=F2.*H;
%             
%             D_vect_round=round(D_mat(:));
% 
%             F2_1D = grpstats(F2(:)', D_vect_round');
%             
%             if k==1
%                 plot(log(1+F2_1D), 'b')
%             else plot(log(1+F2_1D), 'k')
%             end
%         end
% 
%     end

        [sz1, sz2, sz3] = size(im_orig_neut_disp);
        [U, V] = dftuv(sz1, sz2);
        D_mat = sqrt(U.^2 + V.^2);
        filt_sd=8;%16 %32    
        
        H = exp(-(D_mat.^2)./(2*(filt_sd^2)));

        for k=1:2
            if k==1
               im=im_orig_neut_disp(:,:, :);
            else im=recon_im_neut_disp(:,:, :);
            end
            
            im_filt=zeros(sz1, sz2, sz3);
            for cond=1:3
                
                
                F=fft2(im(:,:,cond));
                im_filt(:,:,cond)=real(ifft2(H.*F));
            end
            
            im_filt_RGB = applycform(im_filt,cform_lab2srgb);
            imtool(imresize(im_filt_RGB, 4, 'nearest'))
            
        end
       
            
 end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [im_back] = conv_vect_to_im(im_lab, sz_im, ones_ind, cform_rgb2lab)

sz_comp=size(ones_ind, 1);
%im_vect=zeros(sz_im(:,1)*sz_im(:,2), 3);
im_vect=ones(sz_im(:,1)*sz_im(:,2), 3);
im=zeros(sz_im(1), sz_im(2), 3);

for cond=1:3
    
    tmp=im_lab((cond-1)*sz_comp+1:cond*sz_comp, 1);
    tmp_mn=mean(tmp);
    im_vect(:, cond)=im_vect(:, cond)*tmp_mn;
    
    im_vect(ones_ind, cond)=tmp;
    im(:,:,cond)=reshape(im_vect(:, cond), [sz_im(1) sz_im(2)]);
end

%im=uint8(im);
im_back=im;
% im_back = applycform(im,cform_rgb2lab);

%%uses stack_stims_md ellipse constr to map back vects to ims
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [sz_im, ones_ind]=reverse_ellipse_mask
mn_iod=60;%round(mean(iod))%80%32%!!!keep orig 80 if resizing (since L is based on it)
a=2.25;
b=3.4;
L=mn_iod*10.5;%14; %5.6
ell_templ=design_ellipse(a, b, L);
ell_templ=single(ell_templ);
    %%%%%%%%%%%!!!resize 0.4 for modelling stims
     %ell_templ=round(imresize(ell_templ, 0.4));
     
     
ell_templ=round((ell_templ+fliplr(ell_templ))/2);
ell_templ=round((ell_templ+flipud(ell_templ))/2);
%imtool(ell_templ)
%error     
ell_templ_vect=logical(ell_templ(:));
ones_ind=find(ell_templ);
sz=sum(ell_templ_vect);
sz_im=size(ell_templ)        
         
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

function [U, V] = dftuv(M, N)
%DFTUV Computes meshgrid frequency matrices.
%   [U, V] = DFTUV(M, N) computes meshgrid frequency matrices U and
%   V. U and V are useful for computing frequency-domain filter 
%   functions that can be used with DFTFILT.  U and V are both M-by-N.

% Set up range of variables.
u = 0:(M-1);
v = 0:(N-1);

% Compute the indices for use in meshgrid
idx = find(u > M/2);
u(idx) = u(idx) - M;
idy = find(v > N/2);
v(idy) = v(idy) - N;

% Compute the meshgrid arrays
[V, U] = meshgrid(v, u);

%U=U
%V=V
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 