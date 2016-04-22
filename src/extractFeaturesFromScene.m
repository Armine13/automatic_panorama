function [features, points] = extractFeaturesFromScene(imScene)
%Returns features and points for each image in given scene
% imScene - list of image names
% features - cell array of features
% points - cell array of points

features = {};
points = {};
N = numel(imScene);
for i = 1 : N,
    I = imread(imScene{i});
    
    %Convert to grayscale
    if size(size(I), 2) == 3,
        grayImage = rgb2gray(I);
        rgb = 1;
    else
        rgb = 0;
        grayImage = I;
    end
    points{i} = detectSURFFeatures(grayImage);
    [features{i}, points{i}] = extractFeatures(grayImage, points{i});
end