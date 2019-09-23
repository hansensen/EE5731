
% Load images
image1 = double(rgb2gray(imread('h1.jpg')));
image2 = double(rgb2gray(imread('h2.jpg')));
im = {image1, image2};

image_size = length(im);

keypoints = cell(1,2);
% Get keypoints
for i = 1 : image_size
    figure;
    imshow(im{i}, []);
    % select 4 points from each images
    keypoints(i) = {ginput(4)};
    close;
end

H = h_matrix(keypoints{1}, keypoints{2});

figure;
tform = projective2d(H.');
imshow(imwarp(image2, tform), [])
