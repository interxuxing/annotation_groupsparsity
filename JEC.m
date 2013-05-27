%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Use JEC to compute distance, assuming that each feature
% contributes equally. Since we also stored feature names (FeaName), 
% we can use different distance metric for different features (otherwise
% cannot get good performance). We didn't include this implementation.
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [label, imageID] = JEC(FeaMat, Fea, test, FeaName, alpha, i, scope)

% Using 1NN, kNN, etc
kNN = scope;

dist = zeros(size(FeaMat,1), 1);
for j=1:size(Fea,2)
    FeaMat = Fea{j};
    tstMat = test{j};
    dist = dist + GetL1Dist(FeaMat, tstMat(i,:), alpha(j));
%     dist = dist + GetKLDist(FeaMat, tstMat(i,:), alpha(j));    
%     dist = dist + GetL2Dist(FeaMat, tstMat(i,:), alpha(j));
%     dist = dist + GetchiSquareDist(tstMat(i,2:end), FeaMat(:,2:end));
end
label = [];
imageID = [];
if(kNN > 1)
    distTmp = sort(dist);
    distTmp = distTmp(1:kNN);
    for k=1:kNN
        id = find(dist == distTmp(k));
        label = [label, FeaMat(id(1),1)];
        imageID = [imageID, id(1)];
    end
else
    id = find(dist == min(dist));
    label = FeaMat(id(1), 1);
    imageID = id(1);
end