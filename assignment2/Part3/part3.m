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
im1 = permute(rgbImage1,[2 1 3]);
im2 = permute(rgbImage2,[2 1 3]);
img1 = reshape(im1,1,[],3);
img2 = reshape(im2,1,[],3);

% set parameters
% disparity = 0.001:0.001:0.06;
disparity = 0.001:0.001:0.02;
Eps = 50; 
Ws = 20/(disparity(end) - disparity(1));

sigma_c = 10;
num_classes = size(disparity,2);
nn = 0.05*(disparity(end) - disparity(1));

% calculate epipolar lines according to the equation given
x_h = [repmat(1:W,1,H);
       reshape(repmat(1:H,W,1),1,num_pixels); 
       ones(1,num_pixels)];
   
first_term = Kt2*Rt2.'*Rt1*inv(Kt1)*x_h;
second_term = Kt2*Rt2.'*(Tt1-Tt2)*disparity;

projected = [];
for i=1:length(disparity)
    second_term_with_disparity_i = second_term(:,i);
    projected_pixels = get_projected_pixel(first_term, second_term_with_disparity_i,...
    H, W);
    projected = [projected; projected_pixels]; 
end

% calculate data term
% get projected img2
img2 = reshape(img2(1,projected,:), num_classes, num_pixels,[]);
img1 = repmat(img1,num_classes,1);
% calculate unary
unary = sqrt(sum((img2 - img1).^2,3));
%%

% calculate sparse matrix
connected_pixels = get_connected_pixels(W, H);
lambda = get_lambda(connected_pixels, Eps, Ws, im1);
PAIRWISE = sparse(connected_pixels(:,1),connected_pixels(:,2), double(lambda),num_pixels,num_pixels,4*num_pixels);

% calculate labelcost
Labelcost = pdist2(disparity',disparity');
Labelcost(Labelcost>nn) = nn;

% class normalization
segclass = disparity(end)*ones(1,num_pixels);

% normalize unary
unary = sigma_c./(sigma_c + unary);
maximm = max(unary);
unary = unary./repmat(maximm,num_classes,1);
unary = 1 - unary;

%%
toc
disp('Begin Optimization')
tic
addpath('../GCMex')
[DispClass, Einit, Eafter] = GCMex(segclass, single(unary), PAIRWISE, single(Labelcost));

%%
depth_map = reshape(disparity(DispClass+1), W, H);
figure
imshow(mat2gray(depth_map'))
toc