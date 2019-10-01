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

% Compute the output limits  for each transform
for i = 1:length(tformsMatrix)
    % [xLimitsOut,yLimitsOut] = outputLimits(tform,xLimitsIn,yLimitsIn)
    [xlim(i,:), ylim(i,:)] = outputLimits(tformsMatrix(i), [1 imageSize(i, 2)], [1 imageSize(i, 1)]);
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
    warpedImage = imwarp(I, tformsMatrix(i), 'OutputView', panoramaView);

    % Generate a binary mask.
    mask = imwarp(true(size(I,1),size(I,2)), tformsMatrix(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, mask);
    %panorama = step(blender, panorama, warpedImage);
end


%%
figure
imshow(panorama)