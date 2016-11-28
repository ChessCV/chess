function [ outIm, centroids ] = cleanupPieceImage( im, threshold )
outIm = zeros(size(im, 1), size(im, 2));
im = bwmorph(im, 'dilate');
L = bwlabel(im, 8);
imageProps = cell2mat(struct2cell(regionprops(L, 'Area', 'Centroid'))');
rowId = meshgrid(1:size(imageProps, 1), 1)';
imageProps = horzcat(rowId, imageProps);
imageProps = flipud(sortrows(imageProps, 2));
% Data is now stored as [num, size, centroid(Row), centroid(Col)]
imageProps = imageProps(imageProps(:, 2) >= threshold, :);
for i=1:size(imageProps, 1)
    outIm = or(outIm, L == imageProps(i, 1));
end
centroids = imageProps(:, 3:4);
end