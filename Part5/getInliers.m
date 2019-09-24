function [numInliers, inliers] = getInliers(im1ptsCo, im2ptsCo, H, threshold)
    inliers = [];
    transformedPoints = transform(im2ptsCo, H);
    numInliers = 0;
    for i = 1:length(im1ptsCo)
        if sqrt(sum((transformedPoints(i,:) - im1ptsCo(i,:)).^2)) < threshold
            numInliers = numInliers+1;
            inliers(numInliers) = i;
        end
    end
end