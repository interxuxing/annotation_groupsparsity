%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Compute similarity using weighted distance
%
% lassoFea and lassoTst: preprocessed feature vectors
% i: the ith test image
% weights: weights computed from lasso, group lasso, etc.
% scope: "k" for kNN
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [label, imageID] = ComputeSimilarity(lassoFea, lassoTst, i, weights, scope)

load meanDist;

% Using 1NN, kNN, etc
kNN = scope;

testVec = ones(size(lassoFea,1),1) * lassoTst(i,:);
distVec = abs(lassoFea(:,2:size(lassoFea,2)) - testVec);
% minus the mean, intuitively move everything to the origin
distVec = distVec - (ones(size(distVec,1),1)*meanDist);

dist = distVec * weights;
dist = -dist; % larger value means higher similarity

label = [];
imageID = [];
if(kNN > 1)
    distTmp = sort(dist);
    distTmp = distTmp(1:kNN);
    for k=1:kNN
        id = find(dist == distTmp(k));
        label = [label, lassoFea(id(1),1)];
        imageID = [imageID, id(1)];
    end
else
    id = find(dist == min(dist));
    label = lassoFea(id(1), 1);
    imageID = id(1);
end