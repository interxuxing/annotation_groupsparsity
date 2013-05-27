function dist = GetL1Dist(features, test, alpha)
testVec = ones(size(features,1),1) * test;
distVec = abs(features - testVec);
distVec(:,1) = 0;
dist = sum(distVec, 2);
dist = dist / alpha;