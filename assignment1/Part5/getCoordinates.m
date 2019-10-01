function [matchedPointsIn1, matchedPointsIn2] = getCoordinates(matchedKP1, matchedKP2)
    matchedPointsIn1 = zeros(length(matchedKP1),2);
    matchedPointsIn2 = zeros(length(matchedKP2),2);
    % Get matched points
    for i = 1 : length(matchedKP1)
        matchedPointsIn1(i,1) = matchedKP1{i}.Coordinates(2);
        matchedPointsIn1(i,2) = matchedKP1{i}.Coordinates(1);
        matchedPointsIn2(i,1) = matchedKP2{i}.Coordinates(2);
        matchedPointsIn2(i,2) = matchedKP2{i}.Coordinates(1);
    end
end