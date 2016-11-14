function [ hist ] = colorHistogram(X,bins,x,y,h)
    hist = zeros(bins,bins,bins);

    for obs=X'
        col = obs(1);
        row = obs(2);
        R = floor(obs(3)/bins)+1;
        G = floor(obs(4)/bins)+1;
        B = floor(obs(5)/bins)+1;
        r = ( sqrt((row-y)^2+(col-x)^2) / h )^2;
        
        if r < 1
            k = 1-r;
            hist(R,G,B) = hist(R,G,B) + k;
        end
    end

    hist = hist/sum(sum(sum(hist)));
end