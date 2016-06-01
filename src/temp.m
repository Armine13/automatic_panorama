I = imread('c.png');

% figure(),imshow(I)
I = crop(I, true, true, true, true, 0.5);

% G = globe(I);
G = I;
imshow(G);





