%% Step 1 - Load images and 

clc;
clear;

addpath('../Part3')
addpath('../Part2')
image1 = imread('../assg1/im01.jpg');
image2 = imread('../assg1/im02.jpg');
images = {image1, image2};
imageSize = zeros(length(images),2);
for i = 1:length(images)
    imageSize(i, :) = size(rgb2gray(images{i}));
end
keyPoints1 = SIFT(double(rgb2gray(image1)),3,5,1.6);
keyPoints2 = SIFT(double(rgb2gray(image2)),3,5,1.6);

%% Step 2: Find the best matched points
matchedKP1 = keyPoints1;
matchedKP2 = cell(length(keyPoints1));

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
    matchedKP2{i} = keyPoints2{bestMatch};
end

% Check if all the key points are correct
% image2Figure = SIFTKeypointVisualizer(image2,matchedPoints1);
% figure;
% imshow(uint8(image2Figure));
% 
% image1Figure2 = SIFTKeypointVisualizer(image1,keyPoints1);
% figure;
% imshow(uint8(image1Figure2));

[matchedPointsIn1, matchedPointsIn2] = getCoordinates(matchedKP1, matchedKP2);

%% Plot all the matches
figure; ax = axes;
showMatchedFeatures(image1,image2,matchedPointsIn1,matchedPointsIn2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%% Step 3 - Get the Best Homography Matrix Using RANSAC

H = RANSAC(matchedKP1, matchedKP2, image1, image2);

tforms(length(images)) = projective2d(eye(3));
tforms(2) = projective2d(H.');

%% Step 4 - Compute the output limits and create the corresponding panaroma

% Compute the output limits  for each transform
for i = 1:length(tforms)
    % [xLimitsOut,yLimitsOut] = outputLimits(tform,xLimitsIn,yLimitsIn)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i, 2)], [1 imageSize(i, 1)]);    
end


maxImageSize = max(imageSize);

% Find the minimum and maximum output limits 
xMin = min([1; xlim(:)]);
xMax = max([maxImageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([maxImageSize(1); ylim(:)]);

% Width and height of panorama.
width  = round(xMax - xMin);
height = round(yMax - yMin);

% Initialize the "empty" panorama.
panorama = zeros([height width 3], 'like', images{1});

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the panorama
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:length(images)
    
    I = images{i};
   
    % Transform I into the panorama.
    warpedImage = imwarp(I, tforms(i), 'OutputView', panoramaView);
                  
    % Generate a binary mask.    
    mask = imwarp(true(size(I,1),size(I,2)), tforms(i), 'OutputView', panoramaView);
    
    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
    %panorama = step(blender, panorama, warpedImage);
end

figure
imshow(panorama)
