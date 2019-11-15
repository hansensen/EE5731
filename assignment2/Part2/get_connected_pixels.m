function connected_pixels = get_connected_pixels(width,height)

% This function returns a list of directed connected pixels
% with given height and width.
num_pixels = width*height;

% up and down
left_nodes = (1:num_pixels)';
left_nodes((width:width:num_pixels))=[];
right_nodes = left_nodes+1;
% connect right node
src = [left_nodes;right_nodes];
% connect left node
dest = [right_nodes;left_nodes];

% left and right
% remove last layer
upper_node = (1:num_pixels-width)';
% add first layer
right_nodes = upper_node+width;
src = [src;upper_node;right_nodes];
dest = [dest;right_nodes;upper_node];

connected_pixels = [src,dest];
end