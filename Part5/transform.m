function transformedPoints = transform(imgPoints,H)
    transformedPoints = zeros(length(imgPoints), 2);

    for i = 1 : length(imgPoints)
        % Multiply H with point image point
        homogeneousCoord = [imgPoints(i,:) 1]';
        result = H*homogeneousCoord;
        % Normalise the coordinates with last term
        result = result / result(3, 1);
        transformedPoints(i,:) = result(1:2,1)';
    end
end