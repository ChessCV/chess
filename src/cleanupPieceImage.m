function [ outIm, centroids ] = cleanupPieceImage( im, threshold, dil )
outIm = zeros(size(im, 1), size(im, 2));
for i=1:dil
    im = bwmorph(im, 'dilate');
end
L = uint8(bwlabel(im, 8));
imageProps = cell2mat(struct2cell(regionprops(L, 'Area', 'Centroid'))');
rowId = meshgrid(1:size(imageProps, 1), 1)';
imageProps = horzcat(rowId, imageProps);
imageProps = flipud(sortrows(imageProps, 2));
% Data is now stored as [num, size, centroid(Col), centroid(Row)]
imageProps = imageProps(imageProps(:, 2) >= threshold, :);
for i=1:size(imageProps, 1)
    outIm = or(outIm, L == imageProps(i, 1));
end
centroids = imageProps(:, 3:4);
end
