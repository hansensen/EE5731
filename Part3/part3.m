
% Load images
image1 = im2double(rgb2gray(imread('h1.jpg')));
image2 = im2double(rgb2gray(imread('h2.jpg')));
im = {image1, image2};

image_size = length(im);

keypoints = cell(1,2);
% Get keypoints
for i = 1 : image_size
    figure;
    imshow(im{i});
    % select 4 points from each images
    keypoints(i) = {ginput(4)};
    close;
end

% Construct Matrix A
A = zeros(8, 9);
point_num = 4;
for i = 1 : point_num
    % Row i  : [x y 1 0 0 0 -x'x  -x'y  -x']
    % Row i+1: [0 0 0 x y 1 -y'x  -y'y  -y']
    targetPoint = keypoints{1};
    originalPoint = keypoints{2};
    threezeros = [0 0 0];
    x = originalPoint(i,1);
    y = originalPoint(i,2);
    x_prime = targetPoint(i, 1);
    y_prime = targetPoint(i, 2);

    A1 = [x y 1 threezeros -1*x_prime*x -1*x_prime*y -1*x_prime];
    A2 = [threezeros x y 1 -1*y_prime*x -1*y_prime*y -1*y_prime];
    A(i * 2 - 1, :) = A1;
    A(i * 2, :) = A2;
end

% Decompose matrix A using SVD
[U,D,V] = svd(A);
h = V(:, end)';
H = zeros(3, 3);

% Construct H matrix
for i = 1 : 3
    H(i, :) = h(:, i*3-2:i*3);
end

figure;
tform = projective2d(H.');
imshow(imwarp(image2, tform))
