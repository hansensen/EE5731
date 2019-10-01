function outputImage = convo(image, kernel)
image = double(image);

% Get the height and width of the image
imageH = size(image, 1);
imageW = size(image, 2);

% Get the height and width of the kernel
kernelH = size(kernel, 1);
kernelW = size(kernel, 2);
outputImage = [];

for i = 1 : imageH - kernelH + 1
    for j = 1 : imageW - kernelW + 1
        targetArea = image(i:i + kernelH - 1, j: j + kernelW - 1);
        sum = 0;
        for k = 1 : kernelH
            for l = 1 : kernelW
                sum = sum + targetArea(k, l) * kernel(k, l);
            end
        end
        outputImage(i, j) = sum;
    end
end
end