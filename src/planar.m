% clear all;

function pan = planar(imageArray, minInliers)
% planar stitching of all input images in imageArray
% minInliers - minimum accepted number of inliers
pan = {};
N = numel(imageArray);
if N < 2, return; end

%% Extract features for all images
[features, points] = extractFeaturesFromScene(imageArray);

%% Find matches between all pairs of images
% And compute homography

adjacency = zeros(N, N);
H = cell(1, N);

%Initialize transform estimator
gte = vision.GeometricTransformEstimator('Transform', 'Projective',...
    'NumRandomSamplingsMethod','Desired confidence','DesiredConfidence',80);%, 'InlierPercentageSource', 60

%for all pairs of images..
for i = 1 : N - 1,
    for j = i + 1 : N,
        %Find matches
        matchedIndexPairs = matchFeatures(features{i},features{j});
        
        %Skip iteration if less than 50 points matched
        if numel(matchedIndexPairs) < 50,
            continue
        end
        matchedPoints1 = points{i}(matchedIndexPairs(:,1));
        matchedPoints2 = points{j}(matchedIndexPairs(:,2));
        %Estimate homography
        %         [tform1, inlierIdx] = step(gte, matchedPoints2.Location, matchedPoints1.Location);
        [tform2, inlierIdx] = step(gte, matchedPoints1.Location, matchedPoints2.Location);
        
        if sum(inlierIdx == 1) >= minInliers,
            %         H{j}{i} = tform1;
            H{i}{j} = tform2;
            %update adjacency matrix
            adjacency(i, j) = 1;
        end
        %                 end
    end
end
%% Compute panorama for i-th group of images

%find groups of images
groups = findClusters(adjacency);

for i = 1: numel(groups),
    G = groups{i};
    I_group = {};
    for k = 1: numel(G),
        I_group{G(k)} = imageArray{G(k)};
    end
    % pairs = pairsFromAdjacency(G, adjacency);
    pan_im = imagesToPanorama(H, G, I_group, adjacency);
    pan_im( ~any(pan_im(:,:,1),2), :, : ) = [];  %rows
    pan_im( :, ~any(pan_im(:,:,1),1),: ) = [];  %columns
    pan{i} = pan_im;
end

% figure(), imshow(pan);