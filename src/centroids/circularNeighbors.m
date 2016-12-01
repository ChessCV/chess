function [ X ] = circularNeighbors(img,c,r,radius)
% Thanks to Joshua Kahn for the implementation

    % Setup
    [ ir, ic, ~ ] = size(img);
    [ cc, rr ] = meshgrid(1:ic, 1:ir);
    
    % Find where the neighobrs are
    neighobrs = sqrt((rr-r).^2 + (cc-c).^2) < radius;
    [ nr, nc ] = find(neighobrs);

    % Create a lambda/function pointer
    featureFun = @(row, col) horzcat(col, row, reshape(img(row, col, 1:3), 1, []));
    
    % X is a Kx5 matric with <ci,ri,R,G,B>
    X = cell2mat(arrayfun(featureFun, nr, nc, 'UniformOutput', false));
end
