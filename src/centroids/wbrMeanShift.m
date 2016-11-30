% Mean Shift track the White Back Rook
% Name: David Soller
% Last.#: soller.23

v = VideoReader('wbrlift.avi');

radius = 15;
pcc = 645.0;
pcr = 190.0;
bins = 16;
h = 15;
nth = 4;
current = 0;

% Show the initial tracked point
board = double(readFrame(v));
imagesc(board/256)
axis('image');
axis ij;
hold on;
plot(pcc, pcr, '+', 'Color', 'g');
hold off;
pause;

% Initialize everything to the startingBoard image
X = circularNeighbors(board, pcc, pcr, radius);
q_model = colorHistogram(X, bins, pcc, pcr, h);
lfc = pcc;
lfr = pcr;

while hasFrame(v)
    frame = double(readFrame(v));
    current = mod(current, nth);

    if current == 0
        % Make our results matrix with r, c fields
        s = h+1;
        results = zeros(s, 2);
        results(1, :) = [ lfc, lfr ];

        for iter=1:h
            X_2 = circularNeighbors(frame, results(iter, 1), results(iter, 2), radius);
            p_test = colorHistogram(X_2, bins, results(iter, 1), results(iter, 2), h);
            w = meanshiftWeights(X_2, q_model, p_test);

            % Fill in the results for the r, c fields
            results(iter + 1, 1) = sum(w .* X_2(:, 1), 1) / sum(w);
            results(iter + 1, 2) = sum(w .* X_2(:, 2), 1) / sum(w);
        end

        % his print stuff
        imagesc(frame/255);
        axis('image');
        axis ij;

        hold on;
        plot(pcc, pcr, '+', 'Color', 'y'); % Plot starting
        plot(results(s, 1), results(s, 2), '+', 'Color', 'b'); % Plot updated
        hold off;

        lfc = results(s, 1);
        lfr = results(s, 2);
    end
    current = current + 1;
end
