function [ color ] = identifyPieceColor( board, row, col )
% We're making the assumption that if we look 'down' ~50 pixels from the
% centroid and thresholding an averaged 11x11 patch, we can identify the
% color.
board = double(board);
row = int16(row);
col = int16(col);
rowEnd = min([size(board, 1), row + 55]);
patch = board(max([rowEnd-10, 0]):rowEnd, ...
    max([col-5, 0]):min([size(board, 2), col+5]), :);
avg = mean(patch(:));
color = avg >= 64;
end
