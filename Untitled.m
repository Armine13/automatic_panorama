clear all;
% I1 = rgb2gray(imread('1.jpg'));
% I2 = rgb2gray(imread('2.jpg'));
% Ir = I1;
% I = I2;
Ir = (imread('images/yard-00.png'));
for i = 1:8,
%     if i == 4, continue; end
    I = imread((sprintf('images/yard-0%d.png',i)));
    i
%     stitch;
    I1 = Ir;
    I2 = I;
%     Ir = stitch((Ir), I);
    stitch;
%     figure; imshow(Ir); title('Recovered image');
%     figure; imshow(uint8(Ir)); title('Recovered image');
end
figure; imshow(Ir); title('Recovered image');