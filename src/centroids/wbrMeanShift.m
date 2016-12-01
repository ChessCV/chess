% Mean Shift track the White Back Rook
% Name: David Soller
% Last.#: soller.23
figure('units','normalized','outerposition',[0 0 1 1])

v = VideoReader('wbrlift.avi');

radius = 15;
pcc = 645.0;
pcr = 190.0;
bins = 16;
h = 15;
nth = 4;
current = 0;
T = 0.1; % Threshold of "no movement"
above = 50;
horiz = 50;

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

out = VideoWriter('wbrlift_lift');
out.FrameRate = ceil(v.FrameRate/nth);
open(out);

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

            % Fill in the results for the c, r fields
            results(iter + 1, 1) = sum(w .* X_2(:, 1), 1) / sum(w); % c
            results(iter + 1, 2) = sum(w .* X_2(:, 2), 1) / sum(w); % r
            
            % Did it move?
            distMoved = pdist2(results(1, :), results(iter+1, :));
            if (distMoved < T)
                % Didn't move exit
                s = iter + 1;
                break;
            end
        end
        
        frame = frame/255;

        % Detect piece lifting but make sure it's not horizontal move
        if pdist2(pcc, results(s, 1)) < horiz
            if pdist2(pcr, results(s,2)) > above
                frame(:,:,1) = min(frame(:,:,1) + 0.1, 1.0);
            end
        end
        
        % his print stuff
        imagesc(frame);
        axis('image');
        axis ij;

        hold on;
        plot(pcc, pcr, '+', 'Color', 'y'); % Plot starting
        plot(results(s, 1), results(s, 2), '+', 'Color', 'b'); % Plot updated
        ax = gca;
        ax.Units = 'pixels';
        pos = ax.Position;
        marg = 2;
        rect = [-marg, -marg, pos(3)+2*marg, pos(4)+2*marg];
        F = getframe(gca,rect);
        ax.Units = 'normalized';
        hold off;
        
        writeVideo(out, F.cdata);

        lfc = results(s, 1);
        lfr = results(s, 2);
    end
    current = current + 1;
end

close(out);
clear out;
