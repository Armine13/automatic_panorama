% function B = transform(A, B, H)


A = I2;
B = I1;

r = size(B, 1);
c = size(B, 2);

[x,y] = meshgrid(1:size(A,1), 1:size(A,2));
a = [x(:), y(:), ones(length(x(:)), 1)];

t = maketform('perspective', H);
B = imtransform(A,t);

% B = resize(B, r, c);
