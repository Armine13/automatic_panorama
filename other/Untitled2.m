clear all;
% Load images.
imDir = 'images';
imScene = imageSet(imDir);

% Display images to be stitched
%montage(buildingScene.ImageLocation);

% Read the first image from the image set.
I = read(imScene, 1);

% Initialize features for I(1)
if size(size(I), 2) == 3,
    grayImage = rgb2gray(I);
    rgb = 1;
else
    rgb = 0;
    grayImage = I;
end
points = detectSURFFeatures(grayImage);
[features, points] = extractFeatures(grayImage, points);

% Initialize all the transforms to the identity matrix. Note that the
% projective transform is used here because the building images are fairly
% close to the camera. Had the scene been captured from a further distance,
% an affine transform would suffice.
tforms = projective2d(eye(3));
tform_prev = projective2d(eye(3));
k = 1;
tr_idx = [];

tforms(1) = projective2d(eye(3));
tr_idx(1) = 1;
% Iterate over remaining image pairs
for n = 2:imScene.Count

    % Store points and features for I(n-1).
    pointsPrevious = points;
    featuresPrevious = features;

    % Read I(n).
    I = read(imScene, n);

    % Detect and extract SURF features for I(n).
    if size(size(I), 2) == 3,
        grayImage = rgb2gray(I);
    else
        grayImage = I;
    end
    
    points = detectSURFFeatures(grayImage);
    [features, points] = extractFeatures(grayImage, points);

    % Find correspondences between I(n) and I(n-1).
    indexPairs = matchFeatures(features, featuresPrevious, 'Unique', true);
    if length(indexPairs) < 20
        
        continue;
    end
    
    matchedPoints = points(indexPairs(:,1), :);
    matchedPointsPrev = pointsPrevious(indexPairs(:,2), :);

    % Estimate the transformation between I(n) and I(n-1).
    k = k + 1;
    tr_idx(k) = n;
    tforms(k) = estimateGeometricTransform(matchedPoints, matchedPointsPrev,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);

    % Compute T(1) * ... * T(n-1) * T(n)
    tforms(k).T = tform_prev.T * tforms(k).T;
    
    tform_prev = tforms(k);
end

imageSize = size(I);  % all the images are the same size

% Compute the output limits  for each transform
for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);

Tinv = invert(tforms(centerImageIdx));

for i = 1:numel(tforms)
    tforms(i).T = Tinv.T * tforms(i).T;
end

for i = 1:numel(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(2)], [1 imageSize(1)]);
end

% Find the minimum and maximum output limits
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

if width > 5000 || height > 5000
    disp('something went wrong');
    return
end
% Initialize the "empty" panorama.
if rgb == 1,
    panorama = zeros([height width 3], 'like', I);
else
    panorama = zeros([height width], 'like', I);
end

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];

if rgb == 1
    panoramaView = imref2d([height width 3], xLimits, yLimits);
else
    panoramaView = imref2d([height width], xLimits, yLimits);
end
% Create the panorama.
for i = 1:numel(tforms)

    I = read(imScene, tr_idx(i));
    
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, warpedImage(:,:,1));
end

figure
imshow(panorama)
% 
