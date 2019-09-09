function [kernel, s, d] = sobel(size)
% use normalisation factor 1/8 to normalise the kernel
normalisation = 1/8;

% The dafault 3x3 Sobel kernel.
s = normalisation * [1 2 1];
d = [1 0 -1];

% Convolve the default 3x3 kernel to the desired size.
for i = 1 : size - 3
    s = normalisation * conv([1 2 1], s);
    d = conv([1 2 1], d);
end

% Output the kernel.
kernel = s'*d;
end