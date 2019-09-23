clc;
clear;

addpath('../Part3')
image1 = imread('../assg1/im01.jpg');
image2 = imread('../assg1/im02.jpg');
images = {image1, image2};
imageSize = zeros(length(images),2);

for i = 1:length(images)
    imageSize(i, :) = size(rgb2gray(images{i}));
end
keypoints = selectKeyPoints(images, 4);

H = h_matrix(keypoints{1}, keypoints{2});

tforms(length(images)) = projective2d(eye(3));
tforms(2) = projective2d(H.');

%% Step 3 - Compute the output limits and create the corresponding panaroma

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
blender = vision.AlphaBlender;

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
    % panorama = step(blender, panorama, warpedImage, mask);
    panorama = step(blender, panorama, warpedImage);
end

figure
imshow(panorama)
