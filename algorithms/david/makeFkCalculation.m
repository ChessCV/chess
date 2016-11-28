function [ cFkArea ] = makeFkCalculation(targetFk,rPoint,cPoint,wr,wc)
    cFkArea = zeros(wr*wc, 5);

    for r=1:wr
        for c=1:wc
            rp = r+rPoint;
            cp = c+cPoint;
            if r == 1
                cFkArea(c, :) = targetFk(rp,cp,:);
            else
                cFkArea((r-1)*wc+c, :) = targetFk(rp,cp,:);
            end
        end
    end
end