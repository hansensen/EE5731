rgbImage = imread('../assg1/im01.jpg');

sobel_kernel = [-1 0 1; -2 0 2; -1 0 1];
gaussian_kernel = [1 2 1; 2 4 2; 1 2 1];

kernel = sobel(5);

kernel = [1 -1;-1 1]
kernel = [-1 1 -1]
kernel = [-1; 1; -1]

image = convo(double(rgb2gray(rgbImage)), kernel);

imshow(image, [])