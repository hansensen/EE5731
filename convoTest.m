rgbImage = imread('image.jpg');

sobel_kernel = [1 0 -1; 2 0 -2; 1 0 -1];
gaussian_kernel = [1 2 1; 2 4 2; 1 2 1];

kernel = sobel(3)
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);
filteredImageR = convo(redChannel, kernel);
filteredImageG = convo(greenChannel, kernel);
filteredImageB = convo(blueChannel, kernel);

filteredImage(:, :, 1) = filteredImageR;
filteredImage(:, :, 2) = filteredImageG;
filteredImage(:, :, 3) = filteredImageB;

imshow(filteredImage, [])