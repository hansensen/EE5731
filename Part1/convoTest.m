rgbImage = imread('../assg1/im01.jpg');

sobel_kernel = [-1 0 1; -2 0 2; -1 0 1];
gaussian_kernel = [1 2 1; 2 4 2; 1 2 1];

kernel1 = [1 -1;-1 1]
kernel2 = [-1 1 -1]
kernel3 = [-1; 1; -1]
kernel4 = [-1 1]
kernel5 = [-1; 1]
kernel6 = [-1 -1 -1 -1 1 1 1 1; ...
           -1 -1 -1 -1 1 1 1 1; ...
           -1 -1 -1 -1 1 1 1 1; ...
           -1 -1 -1 -1 1 1 1 1; ...
           ]

kernel = kernel6;

image = convo(double(rgb2gray(rgbImage)), kernel);

imshow(image, [])