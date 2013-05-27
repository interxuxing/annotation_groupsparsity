%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Compute weights without any regularization (least square)
%
% Fea: feature matrix
% alpha: bounds to normalize different features
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function weights = GetLSWeights(Fea, alpha)

load positivePairs;
load negativePairs;
positiveNum = size(positivePairs,1);
negativeNum = size(negativePairs,1);

allPairs = [positivePairs;negativePairs];
allNum = size(allPairs,1);

Y = ones(allNum,1);
Y(positiveNum+1:allNum) = -1;
X = [];
for j=1:size(Fea,2)
    FeaMat = Fea{j};
    tmp = abs(FeaMat(allPairs(:,1), 2:size(FeaMat,2)) - FeaMat(allPairs(:,2), 2:size(FeaMat,2))) / alpha(j);
    X = [X,tmp];
end

meanDist = mean(X);
save meanDist meanDist
X = X - ones(size(X,1),1) * meanDist;

weights = pinv(X) * Y;