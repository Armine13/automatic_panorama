function [features, points] = extractFeaturesFromScene(imArray)
%Returns features and points for each image 
% imArray - cell array of images
% features - cell array of features
% points - cell array of points

features = {};
points = {};
N = numel(imArray);
for i = 1 : N,
    I = imArray{i};
    
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