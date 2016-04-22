function keypoints = extractKeypoints(I, N, r)

C = cornermetric(I);
C = [-100*ones(size(C, 1),r) C, -100*ones(size(C, 1),r)];
C = [-100*ones(r, size(C, 2)); C; -100*ones(r, size(C, 2))];
col_vec = zeros(N, 1);
row_vec = zeros(N, 1);
for i = 1 : N,
    [temp, idx] = max(C(:));
    
    [row, col] = ind2sub(size(C), idx);
    
    
    row_vec(i) = row;
    col_vec(i) = col;

    C(row, col) = -100;
    C(row-r:row+r,col-r:col+r) = -100;
end
keypoints = [col_vec, row_vec];
keypoints = keypoints - r;