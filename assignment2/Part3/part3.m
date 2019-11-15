%%
clear
clc

addpath('../GCMex')
addpath('../Part1')
addpath('../Part2')

% load images and camera matrices 
tic
rgbImage1 = double(imread('test00.jpg'));
rgbImage2 = double(imread('test09.jpg'));

% Get the height and width of the image
H = size(rgbImage1, 1);
W = size(rgbImage1, 2);

cameras = readmatrix('cameras.txt');

Kt1 = cameras(1:3, 1:3);
Rt1 = cameras(4:6, 1:3);
Tt1 = cameras(7, 1:3)';

Kt2 = cameras(8:10, 1:3);
Rt2 = cameras(11:13, 1:3);
Tt2 = cameras(14, 1:3)';

num_pixels = W * H;

% rearrange dimension and make it linear
img1 = permute(rgbImage1,[2 1 3]);
img2 = permute(rgbImage2,[2 1 3]);
img1 = reshape(img1,1,[],3);
img2 = reshape(img2,1,[],3);

%%
% set parameters
disparity = 0.0001:0.0002:0.06;
Eps = 40; 
Ws = 20/(disparity(end) - disparity(1));

sigma_c = 10; 
num_classes = size(disparity,2);
nn = 0.05*(disparity(end) - disparity(1));