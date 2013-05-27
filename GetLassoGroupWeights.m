%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Compute weights from 2-1 norm regularization (group lasso)
% Solver is not included here. Please download it from 
% http://www.cs.ubc.ca/~murphyk/Software/L1CRF/index.html
% User needs to manually define groups
%
% Fea: feature matrix
% alpha: bounds to normalize different features
% lambda: tuning parameter which controls the importance of prior
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function weights = GetLassoGroupWeights(Fea, alpha, lambda)

load positivePairs;
load negativePairs;

positiveNum = size(positivePairs,1);
negativeNum = size(negativePairs,1);

allPairs = [positivePairs;negativePairs];
allNum = size(allPairs,1);

Y = ones(allNum,1);
Y(positiveNum+1:allNum) = -1;
X = [];
groupMask = [];
for j=1:size(Fea,2)
    FeaMat = Fea{j};
    tmp = abs(FeaMat(allPairs(:,1), 2:size(FeaMat,2)) - FeaMat(allPairs(:,2), 2:size(FeaMat,2))) / alpha(j);
    X = [X,tmp];
    groupMask = [groupMask; ones(size(FeaMat,2)-1, 1)*j];
end

meanDist = mean(X);
save meanDist meanDist
X = X - ones(size(X,1),1) * meanDist;

sumX = sum(X);
weights = zeros(size(X,2),1);

p = size(X,2);
w = zeros(p,1);
groups = zeros(p,1);

% define groups
groups(1:48)=1;
groups(49:96)=2;
groups(97:144)=3;
groups(145:192)=4;
groups(193:240)=5;
groups(241:288)=6;
groups(289:480)=7;
groups(481:672)=8;
groups(673:864)=9;
groups(865:1056)=10;

nGroups = length(unique(groups(groups>0)));
funObj_sub = @(w)GaussianLoss(w,X,Y);
w_init = zeros(p,1);
% Make Initial Value
w_init = [w_init;zeros(nGroups,1)];
for g = 1:nGroups
    w_init(p+g) = norm(w_init(groups==g));
end

% Make Objective and Projection Function
funObj = @(w)auxGroupLoss(w,groups,lambda,funObj_sub);
funProj = @(w)auxGroupL2Proj(w,groups);
% Solve
wAlpha = minConF_SPG(funObj,w_init,funProj);
i=1;
w(:,i) = wAlpha(1:p);
w_init = w(:,i);
weights = w;
