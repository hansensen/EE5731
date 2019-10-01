function index = getRandIndex(maxIndex, numPts)
% init index
index = zeros(1,numPts);
indexPool = 1:maxIndex;

% Get random indexes in indexPool
rs = ceil(rand(1, numPts).*(maxIndex:-1:maxIndex-numPts+1));

% Check 0
for i = 1:numPts
	while rs(i) == 0
		rs(i) = ceil(rand(1)*(maxIndex-i+1));
	end
	index(i) = indexPool(rs(i));
	indexPool(rs(i)) = [];
end