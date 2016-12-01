function [ hist ] = colorHistogram(X,bins,c,r,h)
    hist = zeros(bins,bins,bins);

    for obs=X'
        x = c - obs(1);
        y = r - obs(2);
        R = floor(obs(3)*bins/256)+1;
        G = floor(obs(4)*bins/256)+1;
        B = floor(obs(5)*bins/256)+1;
        rDist = ( sqrt(x^2 + y^2) / h )^2;
        
        if rDist < 1
            k = 1-rDist;

            % Increment bin
            hist(R,G,B) = hist(R,G,B) + k;
        end
    end

    % Normalize bin
    hist = hist/sum(hist(:));
end
