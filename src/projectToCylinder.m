function out = projectToCylinder(image, f)

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
            if size(image, 3) == 3,
                out(y, x, :) = [image(yimg, ximg, 1) image(yimg, ximg, 2) image(yimg, ximg, 3)];
            else
                out(y, x) = image(yimg, ximg, 1);
            end
        end
                               
    end
end
