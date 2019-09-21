image1 = im2double(rgb2gray(imread('h1.jpg')));
image2 = im2double(rgb2gray(imread('h2.jpg')));
im = {image1, image2};

image_size = length(im);

for i = 1 : image_size
    figure;
    imshow(im{i});
    % select 4 points from each images
    keypoints(i) = {ginput(4)};
    close;
end

