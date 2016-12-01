function [ F ] = Move( eb, i1, i2, ll )
%Move Outputs the move and image of move
%   Uses the images to find two centroids
%   for the piece being moved. One for the
%   before position and one for the after
%   position. Detects pieces prior position
%   using centroid pixels comparision to
%   image of an empty board

EB = double(rgb2gray(imread(eb)));

I1 = double(rgb2gray(imread(i1)));
I2 = double(rgb2gray(imread(i2)));

LL = imread(ll); F = '....';

EB = EB.*(LL>0);

I1 = I1.*(LL>0);
I2 = I2.*(LL>0);

D = imabsdiff(I1,I2);
B = imbinarize(D,'adaptive');

M = bwmorph(B,'open');
M = bwmorph(M,'dilate');
M = bwmorph(M,'erode',4);

A = bwareafilt(M, 2); L = bwlabel(A);
P = regionprops(L,'centroid');
C = cat(1,P.Centroid);

x1 = floor(C(1,1)); y1 = floor(C(1,2));
x2 = floor(C(2,1)); y2 = floor(C(2,2));

Q1 = int8(LL(y1,x1));
Q2 = int8(LL(y2,x2));

T1 = TileCalc(Q1);
T2 = TileCalc(Q2);

I2R1 = I2((y1-45 : y1+45),(x1-45 : x1+45));
I2R2 = I2((y2-45 : y2+45),(x2-45 : x2+45));

EBR1 = EB((y1-45 : y1+45),(x1-45 : x1+45));
EBR2 = EB((y2-45 : y2+45),(x2-45 : x2+45));

I2M1 = mean(I2R1(:));
I2M2 = mean(I2R2(:));

EBM1 = mean(EBR1(:));
EBM2 = mean(EBR2(:));

figure;
imagesc(A); colormap('gray'); hold on

if ((abs(I2M1-EBM1)-abs(I2M2-EBM2)) < 0)
    F = sprintf('%s%s', T1,T2);
    plot(C(1,1),C(1,2), 'b*')
    plot(C(2,1),C(2,2), 'r*') 
else
    F = sprintf('%s%s', T2,T1);
    plot(C(1,1),C(1,2), 'r*')
    plot(C(2,1),C(2,2), 'b*') 
end
hold off

end