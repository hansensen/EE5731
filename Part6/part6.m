%%
clc;
clear;


addpath('../Part3')
addpath('../Part2')
%image1 = imread('../assg1/im01.jpg');
image2 = imread('../assg1/im02.jpg');
image3 = imread('../assg1/im03.jpg');
image4 = imread('../assg1/im04.jpg');
image5 = imread('../assg1/im05.jpg');

images = {image2, image3};
imageSize = zeros(length(images),2);
for i = 1:length(images)
    imageSize(i, :) = size(rgb2gray(images{i}));
end
%%
tforms(length(images)) = projective2d(eye(3));
%%

for i = 2:length(images)
    tforms(i) = getTform(images{i}, images{i-1});
    tforms(i).T = tforms(i).T * tforms(i-1).T; 
end
