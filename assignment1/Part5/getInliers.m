function [numInliers, inliers, error] = getInliers(im1ptsCo, im2ptsCo, H, threshold)
    inliers = [];
    transformedPoints = transform(im2ptsCo, H);
    numInliers = 0;
    error = 0;
    for i = 1:length(im1ptsCo)
        dist = sqrt(sum((transformedPoints(i,:) - im1ptsCo(i,:)).^2));
        if dist < threshold
            numInliers = numInliers+1;
            inliers(numInliers) = i;
            error = error + dist;
        end
    end
end