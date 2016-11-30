function [ w ] = meanshiftWeights(X, q_model, p_test)
    w = zeros(size(X, 1), 1);
    
    for iter=1:size(w, 1)
        bins = size(q_model, 1);
        R = floor(X(iter, 3)*bins/256)+1;
        G = floor(X(iter, 4)*bins/256)+1;
        B = floor(X(iter, 5)*bins/256)+1;
        
        w(iter) = sqrt(q_model(R, G, B) / p_test(R, G, B));
    end
end
