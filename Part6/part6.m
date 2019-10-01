%%
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

%%
tforms(length(images)) = projective2d(eye(3));
%%

for i = 2:length(images)
    disp(['Getting tform of image ' num2str(i)])
    tforms(i) = getTform(images{i-1}, images{i});
    tforms(i).T = tforms(i).T * tforms(i-1).T; 
end

disp('Got all tforms')

for i = 1:length(tforms)
    [xlim(i,:), ylim(i,:)] = outputLimits(tforms(i), [1 imageSize(i,2)], [1 imageSize(i,1)]);    
end

%%
% Next, compute the average X limits for each transforms and find the image
% that is in the center. Only the X limits are used here because the scene
% is known to be horizontal. If another set of images are used, both the X
% and Y limits may need to be used to find the center image.

avgXLim = mean(xlim, 2);

[~, idx] = sort(avgXLim);

centerIdx = floor((numel(tforms)+1)/2);

centerImageIdx = idx(centerIdx);

%%
% Finally, apply the center image's inverse transform to all the others.

Tinv = invert(tforms(centerImageIdx));

for i = 1:length(tforms)
    tforms(i).T = tforms(i).T * Tinv.T;
end

%% Step 3 - Initialize the Panorama
% Now, create an initial, empty, panorama into which all the images are
% mapped.
%
% Use the |outputLimits| method to compute the minimum and maximum output
% limits over all transformations. These values are used to automatically
% compute the size of the panorama.

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


%%
figure
imshow(panorama)