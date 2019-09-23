%% Step 1 - Load images and manually select matched keypoints between images

clc;
clear;

addpath('../Part3')
addpath('../Part2')
image1 = double(rgb2gray(imread('../assg1/im01.jpg')));
image2 = double(rgb2gray(imread('../assg1/im02.jpg')));
images = {image1, image2};
image_size = zeros(length(images),2);
keypoints = cell(1,length(images));

keyPoints1 = SIFT(image1,5,5,1.6);
keyPoints2 = SIFT(image2,5,5,1.6);
matchedPoints1 = cell(length(keyPoints1));

for i = 1:length(keyPoints1)
    minDist = sqrt(sum((keyPoints1{i}.Descriptor - keyPoints2{1}.Descriptor).^2));
    bestMatch = 1;
    for j = 2:length(keyPoints2)
        euclideanDist = sqrt(sum((keyPoints1{i}.Descriptor - keyPoints2{j}.Descriptor).^2));
        if (euclideanDist < minDist)
            minDist = euclideanDist;
            bestMatch = j;
        end
    end
    matchedPoints1{i} = keyPoints2{bestMatch};
end

% Check if all the key points are correct
% image2Figure = SIFTKeypointVisualizer(image2,matchedPoints1);
% figure;
% imshow(uint8(image2Figure));
% 
% image1Figure2 = SIFTKeypointVisualizer(image1,keyPoints1);
% figure;
% imshow(uint8(image1Figure2));

matchedPointsIn1 = zeros(length(keyPoints1),2);
matchedPointsIn2 = zeros(length(keyPoints1),2);
% Get matched points
for i = 1 : length(keyPoints1)
    matchedPointsIn1(i,1) = keyPoints1{i}.Coordinates(2);
    matchedPointsIn1(i,2) = keyPoints1{i}.Coordinates(1);
    matchedPointsIn2(i,1) = matchedPoints1{i}.Coordinates(2);
    matchedPointsIn2(i,2) = matchedPoints1{i}.Coordinates(1);
end

% Plot all the matches
figure; ax = axes;
showMatchedFeatures(image1,image2,matchedPointsIn1,matchedPointsIn2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%% Step 2 - Get the Best Homography Matrix Using RANSAC

H_RANSAC = RANSAC(matchedPointsIn1, matchedPointsIn2, image2);
