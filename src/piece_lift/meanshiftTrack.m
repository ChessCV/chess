% Name: David Soller
% Last.#: soller.23
% Assignment: HW 6 - MeanshiftTrack

img1 = double(imread('data/img1.jpg'));
img2 = double(imread('data/img2.jpg'));
radius = 25;
x = 150.0;
y = 175.0;
bins = 16;
h = 25;

% hold on;
% imagesc(img1/255);
% axis('image');
% axis ij;
% plot(x,y,'+','Color','g');
% hold off;
% pause;

X = circularNeighbors(img1, x, y, radius);
q_model = colorHistogram(X, bins, x, y, h);

% Make our results matrix with r, c fields 
results = zeros(h+1, 2);
results(1, :) = [ x, y ];

for iter=1:h
    X_2 = circularNeighbors(img2, results(iter, 1), results(iter, 2), radius);
    p_test = colorHistogram(X_2, bins, results(iter, 1), results(iter, 2), h);
    w = meanshiftWeights(X_2, q_model, p_test);

    % Fill in the results for the r, c fields
    results(iter + 1, 1) = sum(w .* X_2(:, 1), 1) / sum(w);
    results(iter + 1, 2) = sum(w .* X_2(:, 2), 1) / sum(w);
end

% his print stuff

hold on;
imagesc(img2/255);
axis('image');
axis ij;
plot(x, y,'+','Color','y');
plot(results(26, 1), results(26, 2), '+', 'Color', 'b');
hold off;
pause;
