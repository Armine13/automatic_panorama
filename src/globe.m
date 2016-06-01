% pathImage = 'C:\168820033_9f33f26583.jpg';
% pathImage = 'C:/sangirgio.jpg';

function dst = globe(src)
%http://simeonpilgrim.com/blog/2014/11/22/tiny-planets-coding/

src = crop(src, true, false, true, false, 0.9);
src_width = size(src, 2);
src_height = size(src, 1);
src_half_width = src_width / 2;
dst_width = (src_height * 2) + src_width;
dst_height = src_height * 2;
dst_origin_x = dst_width / 2;
dst_origin_y = dst_height / 2;

bend = 1;

bend_x = round(src_half_width * (1.0 - bend));
bent_pixels = src_half_width - bend_x;
final_ang_d = 180.0 * bend;

final_ang = final_ang_d * (pi / 180.0);

dst = zeros(dst_width, dst_height);

bend_start_x = dst_origin_x - bend_x;
bend_end_x = dst_origin_x + bend_x;

for x = 0: dst_width - 1,
    
    if x < dst_origin_x,
        fix_x = bend_x;
    else
        fix_x = -bend_x;
    end
    for y = 0:dst_height - 1,
        if (x > bend_start_x && x < bend_end_x),
            % rectanliner
            ox = (x - bend_start_x) + (src_half_width - bend_x);
            
            if (y < src.Height),
                dst.SetPixel(x, y, src.GetPixel(ox, y));
            end
            
        else
            
            % map from output to input
            dx = x - dst_origin_x + fix_x;
            dy = y - dst_origin_y;
            
            r = sqrt((dx * dx) + (dy * dy));
            q = atan2(dy, dx);
            
            pic_ang = q + (pi / 2.0);
            mod_ang = mod(pic_ang + pi, pi * 2) - pi;
            
            if (abs(mod_ang) <= final_ang),
                
                dev_x = round((mod_ang / final_ang) * bent_pixels) - fix_x + src_half_width;
                dev_y = round(r);
                
                if (dev_x < src_width && dev_x >= 0 && dev_y < src_height && round(dev_x)+1 <=src_width && round(src_height - dev_y) <= src_width && round(src_height - dev_y) > 0),
                    for dim = 1:size(src, 3),
                        dst(y+1, x+1, dim) = src(round(src_height - dev_y), round(dev_x)+1, dim);
                    end
                end
            end
        end
    end
end
%remove empty rows and columns
dst( ~any(dst(:,:,1),2), :, : ) = [];  %rows
dst( :, ~any(dst(:,:,1),1),: ) = [];  %columns