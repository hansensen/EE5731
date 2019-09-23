function inliers = getInliers(matchedPointsIn1, matchedPointsIn2, H, threshold)
    transformedPoints = transform(matchedPointsIn2, H);
    numInliers = 0;
    for i = 1:length(matchedPointsIn1)
        if sqrt(sum((transformedPoints(i,:) - matchedPointsIn1(i,:)).^2)) < threshold
            numInliers = numInliers+1;
            inliers(numInliers) = i;
        end
    end
end