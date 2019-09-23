function keypoints = selectKeyPoints(im, n_pts)
    keypoints = cell(1,length(im));
    % Get keypoints
    for i = 1 : length(im)
        figure;
        imshow(im{i}, []);
        % select 4 points from each images
        keypoints(i) = {ginput(n_pts)};
        close;
    end
end