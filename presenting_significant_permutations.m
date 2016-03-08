perm60=pIdsH;
perm60(~isnan(perm60))=1;
perm60(isnan(perm60))=0;


out=NaN(60,1);
for i=1:60
    perm59=squeeze(outMatGen_happ(i,:,:))';
    out(i)=sum(sum(perm59.*perm60));
end
perm60=perm60*0.5;
% figure
% subplot(1,3,1)
% imagesc([squeeze(outMatGen_happ(:,:,1)); squeeze(perm60(1,:))]);
% title('L channel')
% subplot(1,3,2)
% imagesc([squeeze(outMatGen_happ(:,:,2)); squeeze(perm60(2,:))]);
% title('A channel')
% subplot(1,3,3)
% imagesc([squeeze(outMatGen_happ(:,:,3)); squeeze(perm60(3,:))]);
% title('B channel')
a=[squeeze(outMatGen_happ(:,:,1));squeeze(perm60(1,:))];
b=[squeeze(outMatGen_happ(:,:,2));squeeze(perm60(2,:))];
c=[squeeze(outMatGen_happ(:,:,3));squeeze(perm60(3,:))];

figure
subplot(1,3,1)
imagesc(a);
title('L channel')
subplot(1,3,2)
imagesc(b);
title('A channel')
subplot(1,3,3)
imagesc(c);
title('B channel')
suptitle('Happy Early results')

a=[squeeze(outMatGen_neut(:,:,1));squeeze(perm60(1,:))];
b=[squeeze(outMatGen_neut(:,:,2));squeeze(perm60(2,:))];
c=[squeeze(outMatGen_neut(:,:,3));squeeze(perm60(3,:))];

figure
subplot(1,3,1)
imagesc(a);
title('L channel')
subplot(1,3,2)
imagesc(b);
title('A channel')
subplot(1,3,3)
imagesc(c);
title('B channel')
suptitle('Neutral Early results')

a=[squeeze(outMatGen_happ1(:,:,1));squeeze(perm60(1,:))];
b=[squeeze(outMatGen_happ1(:,:,2));squeeze(perm60(2,:))];
c=[squeeze(outMatGen_happ1(:,:,3));squeeze(perm60(3,:))];

figure
subplot(1,3,1)
imagesc(a);
title('L channel')
subplot(1,3,2)
imagesc(b);
title('A channel')
subplot(1,3,3)
imagesc(c);
title('B channel')
suptitle('Happy Late results')

a=[squeeze(outMatGen_neut1(:,:,1));squeeze(perm60(1,:))];
b=[squeeze(outMatGen_neut1(:,:,2));squeeze(perm60(2,:))];
c=[squeeze(outMatGen_neut1(:,:,3));squeeze(perm60(3,:))];

figure
subplot(1,3,1)
imagesc(a);
title('L channel')
subplot(1,3,2)
imagesc(b);
title('A channel')
subplot(1,3,3)
imagesc(c);
title('B channel')
suptitle('Neutral Late results')