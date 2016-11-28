function [ FEN ] = updateFEN( FEN, grayBoard, row, col, fen )
row = int16(min(row+70, size(grayBoard, 1)));
col = int16(col);
location = grayBoard(row, col);
FEN = rot90(FEN, 1);
if location > 0
    FEN(location) = {fen};
end
FEN = rot90(FEN, 3);
end
