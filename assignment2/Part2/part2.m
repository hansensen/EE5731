%%
addpath('../GCMex')
addpath('../Part1')

m_lambda = 1;

rgbImage1 = imread('./im1_scaled.png');
rgbImage2 = imread('./im2_scaled.png');

% Get the height and width of the image
H = size(rgbImage1, 1);
W = size(rgbImage1, 2);

num_pixels = W * H;
num_classes = W;

segclass = zeros(num_pixels, 1);
unary = zeros(num_classes, num_pixels);
[X Y] = meshgrid(1:num_classes, 1:num_classes);
labelcost = min(4, (X - Y).*(X - Y));

num_edges = H * (W -1) + W * (H - 1);
i = zeros(1, num_edges);
j = zeros(1, num_edges);
adjacent = zeros(1,num_edges);
edge_index = 1;
% pairwise = sparse(num_pixels,num_pixels);

%%
for row = 0:H-1
  for col = 0:W-1
    pixel_index = 1+ row * W + col;

    % data term:
    pixel1 = reshape(rgbImage1(row+1, col+1,:),[1,3]);
    for col2 = 1:W
        pixel2 = reshape(rgbImage2(row+1, col2,:),[1,3]);
        unary(col2, pixel_index) = getDistance(pixel1, pixel2);
    end

    % prior term: start
%     currentPixel = reshape(rgbImage(row+1, col+1,:),[1,3]);
% 
%     if row+1 < H
%         i(edge_index) = pixel_index;
%         j(edge_index) = 1+col+(row+1)*W;
%         adjacent(edge_index) = 1;
%         edge_index = edge_index +1;
%     end
%
%     if row-1 >= 0
%         i(edge_index) = pixel_index;
%         j(edge_index) = 1+col+(row-1)*W;
%         adjacent(edge_index) = 1;
%         edge_index = edge_index +1;
%     end
% 
%     if col+1 < W
%         i(edge_index) = pixel_index;
%         j(edge_index) = 1+(col+1)+row*W;
%         adjacent(edge_index) = 1;
%         edge_index = edge_index +1;
%     end
% 
%     if col-1 >= 0
%         i(edge_index) = pixel_index;
%         j(edge_index) = 1+(col-1)+row*W;
%         adjacent(edge_index) = 1;
%         edge_index = edge_index +1;
%     end
    % prior term: end
  end
end

%%
adjacent = adjacent *m_lambda;
pairwise = sparse(i,j ,adjacent);
[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),1);
fprintf('E: %d , Eafter: %d \n', E, Eafter);
fprintf('unique(labels) should be [0 4] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');
%%

figure;
imshow(uint8(final_img))