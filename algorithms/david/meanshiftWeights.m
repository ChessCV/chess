function [ w ] = meanshiftWeights(X,q_model,p_test)
    w = sqrt(q_model ./ p_test);
end