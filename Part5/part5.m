%%
clc;
clear;


addpath('../Part3')
addpath('../Part2')
image1 = imread('../assg1/im03.jpg');
image2 = imread('../assg1/im04.jpg');

%%
panorama = getPanorama(image1, image2);

%%
figure
imshow(panorama)