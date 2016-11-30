board = double(imread('startingBoard.jpg'));

% Assuming r, c
centroids = csvread('centroids.csv');

hold on;
imagesc(board/255);
axis('image');
axis ij;
plot(centroids(:, 2), centroids(:, 1), '+', 'Color', 'b');
hold off;
