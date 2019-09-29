function tform = getTform(image1, image2)
    %% Step 1 - Load images and 
    keyPoints1 = SIFT(double(rgb2gray(image1)),3,5,1.6);
    keyPoints2 = SIFT(double(rgb2gray(image2)),3,5,1.6);

    %% Step 2: Find the best matched points
    matchedKP1 = keyPoints1;
    matchedKP2 = cell(length(keyPoints1));

    for i = 1:length(keyPoints1)
        minDist = sqrt(sum((keyPoints1{i}.Descriptor - keyPoints2{1}.Descriptor).^2));
        bestMatch = 1;
        for j = 2:length(keyPoints2)
            euclideanDist = sqrt(sum((keyPoints1{i}.Descriptor - keyPoints2{j}.Descriptor).^2));
            if (euclideanDist < minDist)
                minDist = euclideanDist;
                bestMatch = j;
            end
        end
        matchedKP2{i} = keyPoints2{bestMatch};
    end

    [matchedPointsIn1, matchedPointsIn2] = getCoordinates(matchedKP1, matchedKP2);

    %% Plot all the matches
    figure; ax = axes;
    showMatchedFeatures(image1,image2,matchedPointsIn1,matchedPointsIn2,'montage','Parent',ax);
    title(ax, 'Candidate point matches');
    legend(ax, 'Matched points 1','Matched points 2');

    %% Step 3 - Get the Best Homography Matrix Using RANSAC
    H = RANSAC(matchedKP1, matchedKP2);

    tform = projective2d(H.');

end