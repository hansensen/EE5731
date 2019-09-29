function bestH = RANSAC(matchedKP1,matchedKP2, image1, image2)   
    %% Determination of Inliers
    N_pts = length(matchedKP1); % total no. of points
    distThreshold = 5;
    N_iter = 0;
    bestMatchedInliers = [];
    maxInliers = 0;
    currentError = 1.e1000;
    while (maxInliers < 80 && N_iter < 500000)
        N_iter = N_iter + 1;
        %% Random sample
        % Randomly Select 5 unique point pairs
        numPts = 5;
        randIndexes = getRandIndex(N_pts,numPts);
        im1pts = matchedKP1(randIndexes);
        im2pts = matchedKP2(randIndexes);

        im1ptsCo = zeros(numPts,2);
        im2ptsCo = zeros(numPts,2);
        for j = 1:numPts
            im1ptsCo(j,:) = fliplr(im1pts{j}.Coordinates);
            im2ptsCo(j,:) = fliplr(im2pts{j}.Coordinates);
        end
        %% Compute Homography Matrix H and Get Inliers
        H = h_matrix(im1ptsCo,im2ptsCo);
        [numInliers, ~, ~] = getInliers(im1ptsCo, im2ptsCo, H, distThreshold);
        if (numInliers == numPts)
            % Count number of inliers using H
            [matchedPointsIn1, matchedPointsIn2] = getCoordinates(matchedKP1, matchedKP2);
            [numInliers, matchedInliers, error] = getInliers(matchedPointsIn1, matchedPointsIn2, H, distThreshold);

            if (numInliers >= maxInliers)
                if (numInliers > maxInliers || error < currentError)
                    maxInliers = numInliers;
                    bestMatchedInliers = matchedInliers;
                    currentError = error;
                end
            end
        end
    end

    %% Plot the best matched points
    bestIm1pts = zeros(length(bestMatchedInliers),2);
    bestIm2pts = zeros(length(bestMatchedInliers),2);
    for j = 1: length(bestMatchedInliers)
        bestIm1pts(j,:) = fliplr(matchedKP1{bestMatchedInliers(j)}.Coordinates);
        bestIm2pts(j,:) = fliplr(matchedKP2{bestMatchedInliers(j)}.Coordinates);
    end

    figure; ax = axes;
    showMatchedFeatures(image1,image2,bestIm1pts,bestIm2pts,'montage','Parent',ax);
    title(ax, strcat('Candidate point matches,  ',int2str(maxInliers)));
    legend(ax, 'Matched points 1','Matched points 2');

    %% Calculate New H matrix
     bestH = h_matrix(bestIm1pts,bestIm2pts);
end
