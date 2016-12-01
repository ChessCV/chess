% board = double(imread('startingBoardOld.jpg'));
board = double(imread('startingBoard.jpg'));

% Assuming r, c
centroids = csvread('centroids.csv');

% Combine close centroids
T = 35; % Threshold for same centroid
centroids = centroidDedup(centroids, T);

imagesc(board/255);
axis('image');
axis ij;
hold on;
plot(centroids(:, 2), centroids(:, 1), '+', 'Color', 'b');
hold off;
