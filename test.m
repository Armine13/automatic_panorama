% function imOut = projectToCylinder(image, f)
image = imread('images\keble_a.jpg');
f = 541;
k1  = 1;
k2 = 1;
ydim=size(image, 1);
xdim=size(image, 2);

xc=xdim/2;
yc=ydim/2;

for y=1:ydim
    for x=1:xdim
        theta = (x - xc)/f;
        h = (y - yc)/f;
        xcap = sin(theta);
        ycap = h;
        zcap = cos(theta);
        xn = xcap / zcap;
        yn = ycap / zcap;
        r = xn^2 + yn^2;
            xd = tan(theta);
            yd = h / cos(theta);
        ximg = floor(f * xd + xc);
        yimg = floor(f * yd + yc);
        
        if (ximg > 0 && ximg <= xdim && yimg > 0 && yimg <= ydim)
            out(y, x, :) = [image(yimg, ximg, 1) image(yimg, ximg, 2) image(yimg, ximg, 3)];
        end
                               
    end
end
imshow(out)