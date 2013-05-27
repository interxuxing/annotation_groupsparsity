%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Compute weights from L2 regularization
%
% Fea: feature matrix
% alpha: bounds to normalize different features
% lambda: tuning parameter which controls the importance of prior
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function weights = GetL2RegWeights(Fea, alpha, lambda)

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
save meanDist meanDist % will be used when computing similarity
X = X - ones(size(X,1),1) * meanDist;

XTX = X'*X;

weights = pinv(XTX + lambda*eye(size(XTX))) * X' * Y;
