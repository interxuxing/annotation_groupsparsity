function dist = GetL2Dist(features, test, alpha)
testVec = ones(size(features,1),1) * test;
distVec = abs(features - testVec);
distVec(:,1) = 0;
distVec = distVec.^2;
dist = sum(distVec, 2);
% normalize, assume that each feature contributes equally
dist = dist / alpha; 