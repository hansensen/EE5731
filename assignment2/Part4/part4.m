clear
clc

addpath('../Part2');
addpath('../Part3');
addpath('../GCMex')


% set parameters
disparity = 0.001:0.001:0.01;

epsilon = 50;
Ws = 18/(disparity(end) - disparity(1));

sigma = 10;
num_classes = size(disparity,2);
nn = 0.05*(disparity(end) - disparity(1));
num_frames = 5;
classes = size(disparity,2); 

% read camera matrics
camera = textread('..//Road/cameras.txt','%s');
camera = cellfun(@str2double, camera);
total_frames = camera(1);
camera(1) = [];

for i = 1: total_frames
    index = (21*(i-1) +1):21*i;
    K{i} = reshape(camera(index(1:9)),[3 3])';
    R{i} = reshape(camera(index(10:18)),[3 3])';
    T{i} = reshape(camera(index(19:21)),[1 3])';
end

% read images
files = dir('../Road/src/*.jpg');
images = fullfile('..', 'Road', 'src' , {files.name});
[H,W,c] = size(imread(images{1}));
num_pixels = H*W;

% perpare for image projection
x_h = [repmat(1:W,1,H);
       reshape(repmat(1:H,W,1),1,num_pixels); 
       ones(1,num_pixels)];

% same method as Part3
for i=1:length(files)
    transformed_imgs{i} = double(imread(images{i}));
    transformed_imgs{i} = permute(transformed_imgs{i},[2 1 3]);
    transformed_imgs{i} = reshape(transformed_imgs{i},1,[],3);
end

%%

all = 1:total_frames;
[a, b] = sort(pdist2(all',all'));
b(1,:) = [];

disp('Calculate Data and Prior Term')

for frame_index=100:total_frames
    
    overall_unary = zeros(classes,num_pixels);
    neighbor = b(1:num_frames,frame_index); 
    
    im_org = transformed_imgs{frame_index};
    im_org = repmat(im_org,classes,1);
    
    for neighbor_index=1:length(neighbor)
        j = neighbor(neighbor_index);
        eq6_right = K{j}*R{j}'*(T{frame_index}-T{j});
        eq6_right = eq6_right*disparity;
        eq6_left = K{j}*R{j}'*R{frame_index}*inv(K{frame_index})*x_h;
        
        projected = zeros(classes,num_pixels);
        for i=1:length(disparity)
            second_term_with_disparity_i = eq6_right(:,i);
            projected_pixels = get_projected_pixel(eq6_left, second_term_with_disparity_i,...
            H, W);
            projected(i,:) = projected_pixels;
        end

        projected_img = transformed_imgs{j};
        projected_img = reshape(projected_img(1,projected,:),classes,num_pixels,[]);
        UNARY = sqrt(sum((projected_img - im_org).^2,3)); 
        UNARY = sigma./(sigma + UNARY);
        overall_unary = UNARY + overall_unary;
        
    end
    
    maximm = max(overall_unary);
    overall_unary = overall_unary./repmat(maximm,classes,1);
    overall_unary = 1 - overall_unary;


img = double(imread(images{frame_index}));
img = permute(img,[2 1 3]);
H = size(img, 1);
W = size(img, 2);
connected_pixels = get_connected_pixels(W,H);
lambda= get_lambda(connected_pixels, epsilon, Ws,img);
E =connected_pixels;
pairwise = sparse(E(:,1),E(:,2),double(lambda),num_pixels,num_pixels,4*num_pixels);

% Find Labelcost
labelCost = pdist2(disparity',disparity');
labelCost(labelCost>nn) = nn;

class = disparity(end)*ones(1,num_pixels);

toc
disp('Begin Optimization')
tic
[DispClass, ~, ~] = GCMex(class, single(overall_unary), pairwise, single(labelCost));
Depth = reshape(disparity(DispClass+1), W, H);
filename = [int2str(frame_index),'.jpg'];
Depth = Depth';
imwrite(mat2gray(Depth), filename)
toc
end
