%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Use similarity matrix to compute distance
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [label, imageID] = JEC_SimMat(simiMatrix, labels, scope, i);

similarity = simiMatrix(i, :);
[B, IX] = sort(similarity, 'descend');
imageID = IX(2:scope+1);
label = labels(imageID);