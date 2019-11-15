function lambda = get_lambda(connected_pixels, Eps, Ws, Nums, img)
I1 = img(:,:,1);
I2 = img(:,:,2);
I3 = img(:,:,3);
Intensity = (I1+I2+I3)/3;
heightnew = size(img,1);
widthnew = size(img,2);
addpath('../Part2')

Lower =  Nums - widthnew;
Upper = Nums - widthnew;
Right = Nums - heightnew;
Left = Nums - heightnew;

% edges4connected connection order is: lower, upper, right, left
% Divide E into different neigbors
E_lower = connected_pixels(1:Lower,:);
E_upper = connected_pixels((Nums - widthnew + 1):(Upper+Nums - widthnew) ,:);
E_right = connected_pixels((Upper+Nums - widthnew + 1):(Upper+Nums - widthnew + Right) ,:);
E_left = connected_pixels((Upper+Nums - widthnew + Right + 1):(Upper+Nums - widthnew + Right + Left) ,:);

% From the paper, first step is to find U matrix
ress = zeros(1,Nums);
ress(unique(E_lower(:,1))) = ress(unique(E_lower(:,1))) + 1;
indd_lower = find(ress==1);
indd_lower_not = find(ress==0);
V_lower = 1./(sqrt((Intensity(E_lower(:,1))-Intensity(E_lower(:,2))).^2) +Eps);
Total_lower = zeros(Nums,1);
Total_lower(indd_lower) = V_lower;

ress = zeros(1,Nums);
ress(unique(E_upper(:,1))) = ress(unique(E_upper(:,1))) + 1;
indd_upper = find(ress==1);
indd_upper_not = find(ress==0);
V_upper = 1./(sqrt((Intensity(E_upper(:,1))-Intensity(E_upper(:,2))).^2) +Eps);
Total_upper = zeros(Nums,1);
Total_upper(indd_upper) = V_upper;


ress = zeros(1,Nums);
ress(unique(E_right(:,1))) = ress(unique(E_right(:,1))) + 1;
indd_right = find(ress==1);
indd_right_not = find(ress==0);
V_right = 1./(sqrt((Intensity(E_right(:,1))-Intensity(E_right(:,2))).^2) +Eps);
Total_right = zeros(Nums,1);
Total_right(indd_right) = V_right;


ress = zeros(1,Nums);
ress(unique(E_left(:,1))) = ress(unique(E_left(:,1))) + 1;
indd_left = find(ress==1);
indd_left_not = find(ress==0);
V_left = 1./(sqrt((Intensity(E_left(:,1))-Intensity(E_left(:,2))).^2) +Eps);
Total_left = zeros(Nums,1);
Total_left(indd_left) = V_left;

% This gives how many connections each pixel has
NN = zeros(1,Nums);
NN(unique(E_lower(:,1))) = NN(unique(E_lower(:,1))) + 1;
NN(unique(E_upper(:,1))) = NN(unique(E_upper(:,1))) + 1;
NN(unique(E_right(:,1))) = NN(unique(E_right(:,1))) + 1;
NN(unique(E_left(:,1))) = NN(unique(E_left(:,1))) + 1;

% Now U matrix can be found
U_lambda = NN'./(Total_left + Total_right + Total_upper + Total_lower);

% Remove indexes that are not used
Lambda_lower = Ws.* U_lambda ./ (Total_lower +Eps);
Lambda_lower(indd_lower_not) = [];
Lambda_upper = Ws.* U_lambda ./ (Total_upper +Eps);
Lambda_upper(indd_upper_not) = [];
Lambda_right = Ws.* U_lambda ./ (Total_right +Eps);
Lambda_right(indd_right_not) = [];
Lambda_left = Ws.* U_lambda ./ (Total_left +Eps);
Lambda_left(indd_left_not) = [];

% Combine all lambda values, as in same order as edges4connect.
lambda = [Lambda_lower;Lambda_upper;Lambda_right;Lambda_left];