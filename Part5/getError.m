function error = getError(im1ptsCo, im2ptsCo, H)
    error = 0;
    transformedPoints = transform(im2ptsCo, H);
    for i = 1:length(im1ptsCo)
        dist = sqrt(sum((transformedPoints(i,:) - im1ptsCo(i,:)).^2));
        if dist < threshold
            error = error + dist;
        end
    end
end