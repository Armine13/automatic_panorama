function newIm = crop(Im,left, top, right, bottom, ts)
%crops uneven edged in the image

I = Im;

if size(I, 3) > 1,
    I = rgb2gray(I);
end

N = size(I, 1);
M = size(I, 2);
firstRow = 1;
firstCol = 1;
lastRow = N;
lastCol = M;
% ts = 0.8;
if right
    for x = size(I, 2):-1:1,
        nz =  length(find(I(:, x))) / N;
        if nz < ts
            lastCol = x;
        else
            break
        end
    end
end
if left
    for x = 1:size(I, 2),
        nz =  length(find(I(:, x))) / N;
        if nz < ts
            firstCol = x;
        else
            break
        end
    end
end

if top
    for y = 1:size(I, 1),
        nz =  length(find(I(y, :))) / M;
        if nz < ts
            firstRow = y;
        else
            break
        end
    end
end

if bottom
    for y = size(I, 1):-1:1,
        nz =  length(find(I(y, :))) / M;
        if nz < ts
            lastRow = y;
        else
            break
        end
    end
end
newIm = Im(firstRow:lastRow, firstCol:lastCol,:);