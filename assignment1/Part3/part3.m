
% Load images
image1 = double(rgb2gray(imread('h1.jpg')));
image2 = double(rgb2gray(imread('h2.jpg')));
%% h2 to h1
im = {image1, image2};

keypoints = selectKeyPoints(im, 4);

H = h_matrix(keypoints{1}, keypoints{2});

figure;
tform = projective2d(H.');
imshow(imwarp(image2, tform), [])

H = h_matrix(keypoints{2}, keypoints{1});

figure;
tform = projective2d(H.');
imshow(imwarp(image1, tform), [])