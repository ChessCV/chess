function [ centroids ] = centroidDedup( centroids, T )
% centroidDedup cleans up the centroids using the provided threshold T
    left = -1;
    ss = size(centroids, 1);

    while (left ~= ss || ss > 32)
        left = ss;
        D = pdist2(centroids, centroids);
        [ sc1, sc2 ]  = find(D < T);

        newCent = zeros(ss, 3); % r, c, num
        for iter = 1:size(sc1, 1)
            c1 = sc1(iter);
            c2 = sc2(iter);

            if c1 ~= c2
                cr_1 = centroids(c1, 1);
                cc_1 = centroids(c1, 2);
                cr_2 = centroids(c2, 1);
                cc_2 = centroids(c2, 2);

                % sumRow, sumCol, numCents
                newCent(c1, :) = [ sum([ newCent(c1, 1) cr_1-cr_2 ]) ...
                    sum([ newCent(c1, 2) cc_1-cc_2 ]) ...
                    newCent(c1, 3) + 2 ];
            end
        end

        for itter = 1:ss
            num = max([ 1 newCent(itter, 3) ]);
            centroids(itter, 1) = centroids(itter, 1) - newCent(itter, 1) / num;
            centroids(itter, 2) = centroids(itter, 2) - newCent(itter, 2) / num;
        end
        centroids = unique(centroids, 'rows');
        ss = size(centroids, 1);
    end
end
