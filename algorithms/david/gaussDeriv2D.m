function [ Gx, Gy ] = gaussDeriv2D( sigma )
%GAUSSDERIV2D Summary of this function goes here
%   Detailed explanation goes here
    
    % 2 for both sides, 3 becuase I chose it, 1 for center
    SIZE = 2*ceil(3*sigma) + 1;
    HSIZE = ceil(3*sigma);
    Gx = zeros(SIZE, SIZE);
    Gy = zeros(SIZE, SIZE);
    
    % Told
    x0 = 0;
    y0 = 0;
    rS = linspace(-HSIZE, HSIZE, SIZE);
    cS = linspace(-HSIZE, HSIZE, SIZE);

    % Calculate Gx & Gy
    for r=1:SIZE
        for c=1:SIZE
            rNum = -( rS(r)-x0 );
            cNum = -( cS(c)-y0 );
            denom = 2 * pi * (sigma^4);
            
            eNum = ( (rS(r)-x0)^2 + (cS(c)-y0)^2 );
            eDenom = 2 * (sigma^2);
            e = exp(-1 * (eNum/eDenom));
            
            Gx(r,c) = ( (cNum/denom) * e );
            Gy(r,c) = ( (rNum/denom) * e );
        end
    end
end

