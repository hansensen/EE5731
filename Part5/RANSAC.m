function bestH = RANSAC(matchedKP1,matchedKP2, image1, image2)   
    %% Determination of Inliers
    N_pts = length(matchedKP1); % total no. of points
    distThreshold = 10;
    inliersThreshold = 0.0;
    N_iter = 10000;
    minErr = 99999999;
    bestMatchedInliers = [];
    maxInliers = 0;
    for i = 1:N_iter
        %% Random sample
        % Randomly Select 5 unique point pairs
        randIndexes = getRandIndex(N_pts,5);
        im1pts = matchedKP1(randIndexes);
        im2pts = matchedKP2(randIndexes);

        im1ptsCo = zeros(5,2);
        im2ptsCo = zeros(5,2);
        for j = 1:5
            im1ptsCo(j,:) = fliplr(im1pts{j}.Coordinates);
            im2ptsCo(j,:) = fliplr(im2pts{j}.Coordinates);
        end
        %% Compute Homography Matrix H and Get Inliers
        H = h_matrix(im1ptsCo,im2ptsCo);

        % Count number of inliers using H
        [matchedPointsIn1, matchedPointsIn2] = getCoordinates(matchedKP1, matchedKP2);
        [numInliers, matchedInliers] = getInliers(matchedPointsIn1, matchedPointsIn2, H, distThreshold);
        
        if (numInliers > maxInliers)
            maxInliers = numInliers;
            bestH = H;
            bestMatchedInliers = matchedInliers;
        end
    end

    %% Compute new H
            %Get all point pairs in matrix form
            im1inliers = zeros(numInliers,2);
            im2inliers = zeros(numInliers,2);
            for j = 1:maxInliers
                im1inliers(j,:) = fliplr(matchedKP1{bestMatchedInliers(j)}.Coordinates);
                im2inliers(j,:) = fliplr(matchedKP2{bestMatchedInliers(j)}.Coordinates);
            end
            % Compute new model
            H = h_matrix(im1inliers,im2inliers)

    %% Plot the best matched points
    bestIm1pts = zeros(length(bestMatchedInliers),2);
    bestIm2pts = zeros(length(bestMatchedInliers),2);
    for j = 1: length(bestMatchedInliers)
        bestIm1pts(j,:) = matchedKP1{bestMatchedInliers(j)}.Coordinates;
        bestIm2pts(j,:) = matchedKP2{bestMatchedInliers(j)}.Coordinates;
    end
    
    figure; ax = axes;
    showMatchedFeatures(image1,image2,fliplr(bestIm1pts),fliplr(bestIm2pts),'montage','Parent',ax);
    title(ax, 'Candidate point matches');
    legend(ax, 'Matched points 1','Matched points 2');

end
