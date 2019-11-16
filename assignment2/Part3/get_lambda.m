function lambda = get_lambda(connected_pixels, Eps, Ws, img)

% seperate connected pixels pairs by four directions
% count the number of pairs in each direction

H = size(img,1);
W = size(img,2);
num_pixels = H * W;

down =  num_pixels - W;
up = num_pixels - W + down;
right = num_pixels - H + up;
left = size(connected_pixels);

% seperate into four parts to calculate the distances
connected_pixels_down = connected_pixels(1:down,:);
connected_pixels_up =   connected_pixels(down+1:up,:);
connected_pixels_right =connected_pixels(up+1:right,:);
connected_pixels_left = connected_pixels(right+1:left,:);

% count the connection of each node
num_conn = zeros(1,num_pixels);
num_conn(connected_pixels_down(:,1)) = num_conn(connected_pixels_down(:,1)) + 1;
num_conn(connected_pixels_up(:,1)) = num_conn(connected_pixels_up(:,1)) + 1;
num_conn(connected_pixels_right(:,1)) = num_conn(connected_pixels_right(:,1)) + 1;
num_conn(connected_pixels_left(:,1)) = num_conn(connected_pixels_left(:,1)) + 1;

% separate three channels
red_img = img(:,:,1);
green_img = img(:,:,2);
blue_img = img(:,:,3);
intensity = (red_img+green_img+blue_img)/3;

% From the paper, first step is to find U matrix
base_array = zeros(1,num_pixels);
base_array((connected_pixels_down(:,1))) = base_array(connected_pixels_down(:,1)) + 1;
% label the src and non-src pixels
down_src = base_array==1;
down_non_src = base_array==0;
% calculate the distance and set into a num_pixels length array
dist_down = zeros(num_pixels,1);
dist_down(down_src) = 1/(sqrt((intensity(connected_pixels_down(:,1))-intensity(connected_pixels_down(:,2))).^2) +Eps);

% do the same for all other directions
base_array = zeros(1,num_pixels);
base_array(connected_pixels_up(:,1)) = base_array(connected_pixels_up(:,1)) + 1;
up_src = base_array==1;
up_non_src = base_array==0;
dist_up = zeros(num_pixels,1);
dist_up(up_src) = 1./(sqrt((intensity(connected_pixels_up(:,1))-intensity(connected_pixels_up(:,2))).^2) +Eps);

base_array = zeros(1,num_pixels);
base_array(connected_pixels_right(:,1)) = base_array(connected_pixels_right(:,1)) + 1;
right_src = base_array==1;
right_non_src = base_array==0;
dist_right = zeros(num_pixels,1);
dist_right(right_src) = 1./(sqrt((intensity(connected_pixels_right(:,1))-intensity(connected_pixels_right(:,2))).^2) +Eps);

base_array = zeros(1,num_pixels);
base_array(connected_pixels_left(:,1)) = base_array(connected_pixels_left(:,1)) + 1;
left_src = base_array==1;
left_non_src = base_array==0;
dist_left = zeros(num_pixels,1);
dist_left(left_src) = 1./(sqrt((intensity(connected_pixels_left(:,1))-intensity(connected_pixels_left(:,2))).^2) +Eps);


% calculate U matrix
% num of connections / total distance of all directions
dist_sum = dist_left + dist_right + dist_up + dist_down;
U = num_conn'./dist_sum;

% Remove indexes that are not used
lambda_down = Ws.* U ./ (dist_down+Eps);
lambda_down(down_non_src) = [];
lambda_up = Ws.* U ./ (dist_up+Eps);
lambda_up(up_non_src) = [];
lambda_right = Ws.* U ./ (dist_right+Eps);
lambda_right(right_non_src) = [];
lambda_left = Ws.* U ./ (dist_left+Eps);
lambda_left(left_non_src) = [];

% Combine all lambda values, as in same order as edges4connect.
lambda = [lambda_down;lambda_up;lambda_right;lambda_left];