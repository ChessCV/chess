function [ FEN, centroidList ] = pieceClassification( board, grayBoard ) %#ok<*NODEF>

centroidList = [];
FEN = cell(8);
FEN(:, :) = {'.'};
board = double(board); % Convert to double if not done already.

%% Load/setup pawn data.
load('data/bPawn.mat')
load('data/wPawn.mat')

bRedStd = std(bPawn(:, 1));
bGreenStd = std(bPawn(:, 2));
bBlueStd = std(bPawn(:, 3));

bRedMean = mean(bPawn(:, 1));
bGreenMean = mean(bPawn(:, 2));
bBlueMean = mean(bPawn(:, 3));

wRedStd = std(wPawn(:, 1));
wGreenStd = std(wPawn(:, 2));
wBlueStd = std(wPawn(:, 3));

wRedMean = mean(wPawn(:, 1));
wGreenMean = mean(wPawn(:, 2));
wBlueMean = mean(wPawn(:, 3));

bPawns = and(and((board(:, :, 1) - bRedMean).^2 / bRedStd^2 < 0.5^2, ...
    (board(:, :, 2) - bGreenMean).^2 / bGreenStd^2 < 0.5^2), ...
    (board(:, :, 3) - bBlueMean).^2 / bBlueStd^2 < 0.5^2);

% Tighten the Mahalanobis distance for red on the white pawns because the
% pink on the queen pieces was being picked up a little bit.
wPawns = and(and((board(:, :, 1) - wRedMean).^2 / wRedStd^2 < 0.3^2, ...
    (board(:, :, 2) - wGreenMean).^2 / wGreenStd^2 < 0.5^2), ...
    (board(:, :, 3) - wBlueMean).^2 / wBlueStd^2 < 0.5^2);

pawnsIm = or(bPawns, wPawns);

[~, centroids] = cleanupPieceImage(pawnsIm, 4, 3);
centroidList = vertcat(centroids, centroidList);
for i=1:size(centroids, 1)
    color = identifyPieceColor(board, centroids(i, 2), centroids(i, 1));
    if color % This is true iff the piece is 'white'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'p');
    else     % This is true iff the piece is 'black'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'P');
    end
end

%% Load/setup knights data.
load('data/bKnight.mat')
load('data/wKnight.mat')

bRedStd = std(bKnight(:, 1));
bGreenStd = std(bKnight(:, 2));
bBlueStd = std(bKnight(:, 3));

bRedMean = mean(bKnight(:, 1));
bGreenMean = mean(bKnight(:, 2));
bBlueMean = mean(bKnight(:, 3));

wRedStd = std(wKnight(:, 1));
wGreenStd = std(wKnight(:, 2));
wBlueStd = std(wKnight(:, 3));

wRedMean = mean(wKnight(:, 1));
wGreenMean = mean(wKnight(:, 2));
wBlueMean = mean(wKnight(:, 3));

bKnights = and(and((board(:, :, 1) - bRedMean).^2 / bRedStd^2 < 0.6^2, ...
    (board(:, :, 2) - bGreenMean).^2 / bGreenStd^2 < 0.6^2), ...
    (board(:, :, 3) - bBlueMean).^2 / bBlueStd^2 < 0.6^2);

wKnights = and(and((board(:, :, 1) - wRedMean).^2 / wRedStd^2 < 1^2, ...
    (board(:, :, 2) - wGreenMean).^2 / wGreenStd^2 < 1^2), ...
    (board(:, :, 3) - wBlueMean).^2 / wBlueStd^2 < 1^2);

knightsIm = or(bKnights, wKnights);

[~, centroids] = cleanupPieceImage(knightsIm, 50, 1);
centroidList = vertcat(centroids, centroidList);
for i=1:size(centroids, 1)
    color = identifyPieceColor(board, centroids(i, 2), centroids(i, 1));
    if color % This is true iff the piece is 'white'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'n');
    else     % This is true iff the piece is 'black'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'N');
    end
end

%% Load/setup bishop data.
load('data/bBishop.mat')
load('data/wBishop.mat')

bRedStd = std(bBishop(:, 1));
bGreenStd = std(bBishop(:, 2));
bBlueStd = std(bBishop(:, 3));

bRedMean = mean(bBishop(:, 1));
bGreenMean = mean(bBishop(:, 2));
bBlueMean = mean(bBishop(:, 3));

wRedStd = std(wBishop(:, 1));
wGreenStd = std(wBishop(:, 2));
wBlueStd = std(wBishop(:, 3));

wRedMean = mean(wBishop(:, 1));
wGreenMean = mean(wBishop(:, 2));
wBlueMean = mean(wBishop(:, 3));

bBishops = and(and((board(:, :, 1) - bRedMean).^2 / bRedStd^2 < 2^2, ...
    (board(:, :, 2) - bGreenMean).^2 / bGreenStd^2 < 2^2), ...
    (board(:, :, 3) - bBlueMean).^2 / bBlueStd^2 < 2^2);

wBishops = and(and((board(:, :, 1) - wRedMean).^2 / wRedStd^2 < 1^2, ...
    (board(:, :, 2) - wGreenMean).^2 / wGreenStd^2 < 1^2), ...
    (board(:, :, 3) - wBlueMean).^2 / wBlueStd^2 < 1^2);

bishopsIm = or(bBishops, wBishops);

[~, centroids] = cleanupPieceImage(bishopsIm, 50, 3);
centroidList = vertcat(centroids, centroidList);
for i=1:size(centroids, 1)
    color = identifyPieceColor(board, centroids(i, 2), centroids(i, 1));
    if color % This is true iff the piece is 'white'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'b');
    else     % This is true iff the piece is 'black'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'B');
    end
end

%% Load/setup king data.
load('data/king.mat')

bRedStd = std(king(:, 1));
bGreenStd = std(king(:, 2));
bBlueStd = std(king(:, 3));

bRedMean = mean(king(:, 1));
bGreenMean = mean(king(:, 2));
bBlueMean = mean(king(:, 3));

kings = and(and((board(:, :, 1) - bRedMean).^2 / bRedStd^2 < 1^2, ...
    (board(:, :, 2) - bGreenMean).^2 / bGreenStd^2 < 1^2), ...
    (board(:, :, 3) - bBlueMean).^2 / bBlueStd^2 < 1^2);

kingsIm = kings;

[~, centroids] = cleanupPieceImage(kingsIm, 100, 1);
centroidList = vertcat(centroids, centroidList);
for i=1:size(centroids, 1)
    color = identifyPieceColor(board, centroids(i, 2), centroids(i, 1));
    if color % This is true iff the piece is 'white'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'k');
    else     % This is true iff the piece is 'black'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'K');
    end
end

%% Load/setup queen data.
load('data/queen.mat')

bRedStd = std(queen(:, 1));
bGreenStd = std(queen(:, 2));
bBlueStd = std(queen(:, 3));

bRedMean = mean(queen(:, 1));
bGreenMean = mean(queen(:, 2));
bBlueMean = mean(queen(:, 3));

queens = and(and((board(:, :, 1) - bRedMean).^2 / bRedStd^2 < 4^2, ...
    (board(:, :, 2) - bGreenMean).^2 / bGreenStd^2 < 4^2), ...
    (board(:, :, 3) - bBlueMean).^2 / bBlueStd^2 < 4^2);

queensIm = queens;

[~, centroids] = cleanupPieceImage(queensIm, 50, 2);
centroidList = vertcat(centroids, centroidList);
for i=1:size(centroids, 1)
    color = identifyPieceColor(board, centroids(i, 2), centroids(i, 1));
    if color % This is true iff the piece is 'white'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'q');
    else     % This is true iff the piece is 'black'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'Q');
    end
end

%% Load/setup rook data.
load('data/rook.mat')

bRedStd = std(rook(:, 1));
bGreenStd = std(rook(:, 2));
bBlueStd = std(rook(:, 3));

bRedMean = mean(rook(:, 1));
bGreenMean = mean(rook(:, 2));
bBlueMean = mean(rook(:, 3));

rooks = and(and((board(:, :, 1) - bRedMean).^2 / bRedStd^2 < 3^2, ...
    (board(:, :, 2) - bGreenMean).^2 / bGreenStd^2 < 3^2), ...
    (board(:, :, 3) - bBlueMean).^2 / bBlueStd^2 < 3^2);

rooksIm = rooks;

[~, centroids] = cleanupPieceImage(rooksIm, 100, 1);
centroidList = vertcat(centroids, centroidList);
for i=1:size(centroids, 1)
    color = identifyPieceColor(board, centroids(i, 2), centroids(i, 1));
    if color % This is true iff the piece is 'white'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'r');
    else     % This is true iff the piece is 'black'.
        FEN = updateFEN(FEN,grayBoard,centroids(i,2),centroids(i,1),'R');
    end
end

%% Swap centroid columns.
centroidList = centroidList(:, [2, 1]);
csvwrite('centroids/centroids.csv', centroidList);
FEN = FENString(FEN);

end
