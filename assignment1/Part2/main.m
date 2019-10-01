clear;
clc;
image = imread('im01.jpg');
image = rgb2gray(image);
image = double(image);
keyPoints = SIFT(image,3,5,1.3);
image = SIFTKeypointVisualizer(image,keyPoints);
imshow(uint8(image))


image = imread('im02.jpg');
image = double(rgb2gray(image));

keyPoints = SIFT(image,5,5,1.6);

image = SIFTKeypointVisualizer(image,keyPoints);
imshow(uint8(image));