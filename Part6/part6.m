%% 1. Load image
clc;
clear;

addpath('../Part2')
addpath('../Part3')
addpath('../Part5')

image1 = imread('../assg1/im01.jpg');
image2 = imread('../assg1/im02.jpg');
image3 = imread('../assg1/im03.jpg');
image4 = imread('../assg1/im04.jpg');
image5 = imread('../assg1/im05.jpg');

images = {image1, image2, image3, image4, image5};
imageSize = zeros(length(images),2);
for i = 1:length(images)
    imageSize(i, :) = size(rgb2gray(images{i}));
end

%% 2. Get tform matrix
% tforms matrics
tformsMatrix(length(images)) = projective2d(eye(3));

for i = 2:length(images)
    disp(['Getting tform of image ' num2str(i)])
    tformsMatrix(i) = getTform(images{i-1}, images{i});
    tformsMatrix(i).T = tformsMatrix(i).T * tformsMatrix(i-1).T; 
end

disp('Got all tforms')

%% 3. Calculate the size of the result image
% calculate the output limits  for each transform
for i = 1:length(tformsMatrix)
    % [xLimitsOut,yLimitsOut] = outputLimits(tform,xLimitsIn,yLimitsIn)
    [xOutputLimit(i,:), yOutputLimit(i,:)] = outputLimits(tformsMatrix(i), [1 imageSize(i, 2)], [1 imageSize(i, 1)]);    
end

%% 4. Find the centre image
% get outputlimit average and sort
[~, index] = sort(mean(xOutputLimit, 2));
% the median is the base image
baseIndex = index(floor((numel(tformsMatrix)+1)/2));

%% 5. Transform all the H matrix w.r.t to base image
% get the invert of base image's h matrix
invertMatrix = invert(tformsMatrix(baseIndex));
% change all transform matrix accordingly
for i = 1:length(tformsMatrix)
    tformsMatrix(i).T = tformsMatrix(i).T * invertMatrix.T;
end

%% Step 3 - Initialize the Panorama

%% 3. Calculate the size of the result image
% calculate the output limits  for each transform
for i = 1:length(tformsMatrix)
    % [xLimitsOut,yLimitsOut] = outputLimits(tform,xLimitsIn,yLimitsIn)
    [xOutputLimit(i,:), yOutputLimit(i,:)] = outputLimits(tformsMatrix(i), [1 imageSize(i, 2)], [1 imageSize(i, 1)]);    
end

maxImageSize = max(imageSize);

% get the width and height according to the output limits
width  = round(max([maxImageSize(2); xOutputLimit(:)]) - min([1; xOutputLimit(:)]));
height = round(max([maxImageSize(1); yOutputLimit(:)]) - min([1; yOutputLimit(:)]));

% initialise a result with image1
result = zeros([height width 3], 'like', images{1});

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Define the pararama view size
resultView = imref2d([height width], ...
          [min([1; xOutputLimit(:)]) max([maxImageSize(2); xOutputLimit(:)])], ...
          [min([1; yOutputLimit(:)]) max([maxImageSize(1); yOutputLimit(:)])]);

%% 4. Stitch the images and show the result
for i = 1:length(images)
    % get current image
    image = images{i};

    % transform images to image1 view using tform matrix
    warpedImage = imwarp(image, tformsMatrix(i), 'OutputView', resultView);

    % Generate a binary mask.    
    mask = imwarp(true(size(image,1),size(image,2)), tformsMatrix(i), 'OutputView', resultView);

    % Stitch them together

    % Overlay the warpedImage onto the panorama.
    result = step(blender, result, warpedImage, mask);
end


figure
imshow(result)