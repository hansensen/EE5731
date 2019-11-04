%%
addpath('../GCMex')

m_lambda = 80;
SOURCE_COLOR = [ 0, 0, 255 ]; % blue = foreground
SINK_COLOR = [245, 210, 110 ]; % yellow = background

rgbImage = imread('./bayes_in.jpg');
% Get the height and width of the image
H = size(rgbImage, 1);
W = size(rgbImage, 2);

num_pixels = W * H;
num_classes = 2;

segclass = zeros(num_pixels, 1);
unary = zeros(num_classes, num_pixels);
[X Y] = meshgrid(1:num_classes, 1:num_classes);
labelcost = min(4, (X - Y).*(X - Y));

num_edges = H * (W -1) + W * (H - 1);
i = zeros(1, num_edges);
j = zeros(1, num_edges);
adjacent = zeros(1,num_edges);
edge_index = 1;

%%
for row = 0:H-1
  for col = 0:W-1
    pixel_index = 1+ row * W + col;
    
    % data term:
    pixel = reshape(rgbImage(row+1, col+1,:),[1,3]);
    unary(2, pixel_index) = getDistance(pixel, SOURCE_COLOR);
    unary(1, pixel_index) = getDistance(pixel, SINK_COLOR);
    
    % prior term: start
    currentPixel = reshape(rgbImage(row+1, col+1,:),[1,3]);

    if row+1 < H
        i(edge_index) = pixel_index;
        j(edge_index) = 1+col+(row+1)*W;
        adjacent(edge_index) = 1;
        edge_index = edge_index +1;
    end
    
    if row-1 >= 0
        i(edge_index) = pixel_index;
        j(edge_index) = 1+col+(row-1)*W;
        adjacent(edge_index) = 1;
        edge_index = edge_index +1;
    end

    if col+1 < W
        i(edge_index) = pixel_index;
        j(edge_index) = 1+(col+1)+row*W;
        adjacent(edge_index) = 1;
        edge_index = edge_index +1;
    end

    if col-1 >= 0
        i(edge_index) = pixel_index;
        j(edge_index) = 1+(col-1)+row*W;
        adjacent(edge_index) = 1;
        edge_index = edge_index +1;
    end

    % prior term: end
  end
end

%%
adjacent = adjacent *m_lambda;
pairwise = sparse(i,j ,adjacent);
[labels E Eafter] = GCMex(segclass, single(unary), pairwise, single(labelcost),1);
fprintf('E: %d , Eafter: %d \n', E, Eafter);
fprintf('unique(labels) should be [0 1] and is: [');
fprintf('%d ', unique(labels));
fprintf(']\n');

%%
labels = reshape(labels, W, H)';

final_img = [];
SOURCE_COLOR = [ 0, 0, 255 ]; % blue = foreground
SINK_COLOR = [245, 210, 110 ]; % yellow = background

for row = 1:H
  for col = 1:W
      if (labels(row, col) == 1)
          final_img(row, col, 1) = SOURCE_COLOR(1);
          final_img(row, col, 2) = SOURCE_COLOR(2);
          final_img(row, col, 3) = SOURCE_COLOR(3);
      else
          final_img(row, col,1) = SINK_COLOR(1);
          final_img(row, col,2) = SINK_COLOR(2);
          final_img(row, col,3) = SINK_COLOR(3);
      end
  end
end

figure;
imshow(uint8(final_img))