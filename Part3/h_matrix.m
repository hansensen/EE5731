function H = h_matrix(keypoint1, keypoint2)
    % Construct Matrix A
    A = zeros(8, 9);
    point_num = length(keypoint1);
    for i = 1 : point_num
        % Row i  : [x y 1 0 0 0 -x'x  -x'y  -x']
        % Row i+1: [0 0 0 x y 1 -y'x  -y'y  -y']
        targetPoint = keypoint1;
        originalPoint = keypoint2;
        threezeros = [0 0 0];
        x = originalPoint(i,1);
        y = originalPoint(i,2);
        x_prime = targetPoint(i, 1);
        y_prime = targetPoint(i, 2);

        A1 = [x y 1 threezeros -1*x_prime*x -1*x_prime*y -1*x_prime];
        A2 = [threezeros x y 1 -1*y_prime*x -1*y_prime*y -1*y_prime];
        A(i * 2 - 1, :) = A1;
        A(i * 2, :) = A2;
    end

    % Decompose matrix A using SVD
    [U,D,V] = svd(A);
    h = V(:, end)';
    H = zeros(3, 3);

    % Construct H matrix
    for i = 1 : 3
        H(i, :) = h(:, i*3-2:i*3);
    end
end