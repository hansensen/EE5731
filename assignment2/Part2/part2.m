
%%
clear
clc

addpath('../GCMex')
addpath('../Part1')

tic
rgbImage1 = double(imread('im2.png'));
rgbImage2 = double(imread('im6.png'));

% Get the height and width of the image
H = size(rgbImage1, 1);
W = size(rgbImage1, 2);

% resize irgbImage1 and rgbImage2 to 1 * n * 3
rgbImage1 = flip(rgbImage1 ,1);
rgbImage1 = flip(rgbImage1,2);
rgbImage1 = reshape(rgbImage1,1,[],3);

rgbImage2 = flip(rgbImage2 ,1);
rgbImage2 = flip(rgbImage2,2);
rgbImage2 = reshape(rgbImage2,1,[],3);

num_pixels = W * H;

% set disparity range
disparity = 4:60;

% set classes
segclass = disparity(1) * ones(1,num_pixels);

threshold = 0.02*(disparity(end) - disparity(1));
Labelcost = pdist2(disparity',disparity');
Labelcost(Labelcost>threshold) = threshold;

unary = [];

%%
for k= 1:length(disparity)

    % For each disparity class, remove out of boundary term
    % Then check L2 distance
    t = disparity(k);
    t = H*t;
    img2 = rgbImage2;
    img2(:,1:t,:) = [];
    img1 = rgbImage1;
    img1(:,(num_pixels-t+1):num_pixels,:) = [];
    A = get_l2_dist(img1, img2);
    A = [A 255*3*ones(1,t)];
    unary = [unary;A];
end
%%
% calculate the sparse matrix
red_img = rgbImage1(:,:,1);
green_img = rgbImage1(:,:,2);
blue_img = rgbImage1(:,:,3);

connected_pixels = get_connected_pixels(H, W);
% get distances between two connected pixels
src = connected_pixels(:,1);
dist = connected_pixels(:,2);

red_dist = sqrt((red_img(src)-red_img(dist)).^2);
greeen_dist = sqrt((green_img(src)-green_img(dist)).^2);
blue_dist = sqrt((blue_img(src)-blue_img(dist)).^2);
dist_matrix = red_dist + greeen_dist + blue_dist;

lambda = 0.005;

pairwise = sparse(src, dist, double(dist_matrix),num_pixels, num_pixels, 4* num_pixels);
unary = unary./max(unary(:));

%%
toc
disp('Begin Optimization')
tic
[DispClass, Einit, Eafter] = GCMex(segclass, single(unary), lambda*pairwise, single(Labelcost));
depth_map = disparity(DispClass+1);
%Reshape to image size for display purpose
result = mat2gray(reshape(depth_map, H, W));
result = flip(result ,1);
result = flip(result ,2);
imshow(result)
toc