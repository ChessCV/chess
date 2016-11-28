function [ X ] = circularNeighbors(img,x,y,radius)
    % X is a Kx5 matrix with <xi,yi,R,G,B> 
    [ ir, ic, id] = size(img);
    X = [];
    
    for r=1:ir
        for c=1:ic
            if ((r-y)^2 + (c-x)^2) < radius^2
                X(end+1, :) = [ c r img(r,c,1) img(r,c,2) img(r,c,3) ];
            end
        end
    end
end