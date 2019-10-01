
image = imread('../assgn/im01.jpg');
image = double(rgb2gray(image));

keyPoints = SIFT(image,5,5,1.6);

image = SIFTKeypointVisualizer(image,keyPoints);
imshow(uint8(image));