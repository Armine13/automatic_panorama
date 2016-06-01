function pan = imagesToPanorama(H, G, imArray, adjacency)
%Projects images to common plane
%imDir - directory containing the images
% G - list of indices of images in imDir
% H - cell array of homographies
% adjacency - adjacency matrix for panorama matching

% imDir = 'images';

n = numel(G);

goal_im_idx = G(end);

%Reference image of panorama
H_array = {};
I_array = {};

%For each image, find homography and project
for j = 1:n - 1
    %Find projection sequence between j-th image and reference image
    H_path = graphtraverse(sparse(adjacency), G(j));
    H_path = H_path(1:find(H_path==goal_im_idx));
    
    %Compute corresponding homography
    H_tot = eye(3);
    for  k = 1 : numel(H_path) - 1,
        H_tot = H{H_path(k)}{H_path(k+1)}' * H_tot;
    end
    I_array{j} = double(imArray{G(j)});
    %Homography for j-th image
    H_array{j} = H_tot;
end

I_array{n} = double(imArray{goal_im_idx});%reference image
I_array{n} = double(imArray{goal_im_idx});%reference image
H_array{n} = eye(3);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

[bbox bb_all] = computeBbox(I_array, H_array);
%estimate the size of output panorama
s = (bbox(2) - bbox(1))*(bbox(4) - bbox(3))*size(I_array{1}, 3);

%if bbox too large, return
% if s > 118540000,
%     pan = [];
%     fprintf('Panorama is too large(%d x %d x %d).',bbox(2) - bbox(1),bbox(4) - bbox(3),size(I_array{1},3));
%     return;
% end
%% Centering panorama
%Find mean locations of projected images

% bb_all
avgXLim = mean(bb_all(1:2,:));

[~, idx] = sort(avgXLim);

centerIdx = floor((n+1)/2);
H_correct = inv(H_array{idx(centerIdx)});
for j = 1: n,
    H_array{j} = H_correct * H_array{j};
end
%%

[bbox bb_all] = computeBbox(I_array, H_array);

dim = size(I_array{1},3);
height = bbox(4)-bbox(3)+1;
width = bbox(2)-bbox(1)+1;
fprintf('Panorama size: (%d x %d x %d).',bbox(2) - bbox(1),bbox(4) - bbox(3),size(I_array{1},3));
pan = zeros([height width dim]);
for j = 1: n,
    I_proj = vgg_warp_H(I_array{j}, H_array{j}, 'linear', bbox);%projected image
%           pan = step(blender, pan, I_proj, I_proj(:,:,1));
    pan = max(pan, I_proj);
end
pan = pan/255;