function [ T ] = TileCalc( Q )
%TileCalc Get the tile that the centroid falls in
%   Use the Q value from the bmp file to calculate
%   the row and column that centroid falls in

L = idivide(Q,8,'ceil');
N = (L*8)-Q+1; T = '..';

if (L == 1)
    T = sprintf('a%d',N);
end
if (L == 2)
    T = sprintf('b%d',N);
end
if (L == 3)
    T = sprintf('c%d',N);
end
if (L == 4)
    T = sprintf('d%d',N);
end
if (L == 5)
    T = sprintf('e%d',N);
end
if (L == 6)
    T = sprintf('f%d',N);
end
if (L == 7)
    T = sprintf('g%d',N);
end
if (L == 8)
    T = sprintf('h%d',N);
end

end

