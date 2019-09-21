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

figure; ax = axes;
showMatchedFeatures(image1,image2,matchedPointsIn1,matchedPointsIn2,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points 1','Matched points 2');

%% Step 2 - Compute the homography matrix using SVD and transformation structure
% 
% % H = homography_matrix(keypoint_in, keypoint_out)
% H_21 = h_matrix(keypoints{1}, keypoints{2});
% 
% tforms(length(images)) = projective2d(eye(3));
% tforms(2) = projective2d(H_21.');
% 
% %% Step 3 - Compute the output limits and create the corresponding panaroma
% 
% % Compute the output limits  for each transform
% for i = 1:length(tforms)
%     % [xLimitsOut,yLimitsOut] = outputLimits(tform,xLimitsIn,yLimitsIn)
%     [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 image_size(i, 2)], [1 image_size(i, 1)]);    
% end
% 
% max_image_size = max(image_size);
% 
% % Find the minimum and maximum output limits 
% xMin = min([1; xlim(:)]);
% xMax = max([max_image_size(2); xlim(:)]);
% 
% yMin = min([1; ylim(:)]);
% yMax = max([max_image_size(1); ylim(:)]);
% 
% % Width and height of panorama.
% width  = round(xMax - xMin);
% height = round(yMax - yMin);
% 
% % Create a 2-D spatial reference object defining the size of the panorama
% xLimits = [xMin xMax];
% yLimits = [yMin yMax];
% panorama_view = imref2d([height width], xLimits, yLimits);
% 
% warped_images = cell(1,length(images));
% 
% % Create the panorama
% for i = 1:length(images)
%     image = images{i};   
%     % Transform I into the panorama
%     warped_images{i} = imwarp(image, tforms(i), 'OutputView', panorama_view);          
% end
% 
% 
% figure
% imshow(warped_images{1} + warped_images{2})