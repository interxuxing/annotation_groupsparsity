%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Convert histogram to similarity matrix. When having many
% features, we can combine them together (by multiplying corresponding
% similarity matrices, such as C = A.*B). Thus the evaluation of JEC will 
% be faster.
%
% Usage: Need to manually change which feature to load and the distance 
% metric
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Histogram2SimilarityMatrix()
clear;
load('rgb16');
% load('rgb16saliency');
% load('hsv16');
% load('hsv16saliency');
% load('lab16');
% load('lab16saliency');
% load('opp64');
% load('rg64');
% load('opp64sal');
% load('rg64sal');

simiMatrix = zeros(size(features,1), size(features,1));

for i=1:size(features,1)
%     simiMatrix(i,1:size(features,1)) = GetchiSquareDist(features(i,2:end), features(:,2:end));
%     simiMatrix(i,1:size(features,1)) = GetKLDist(features(:,2:end), features(i,2:end), 1);
    simiMatrix(i,1:size(features,1)) = GetL1Dist(features(:,2:end), features(i,2:end), 1);
end

simiMatrix = simiMatrix / (sum(sum(simiMatrix))/numel(simiMatrix));
simiMatrix = exp(-simiMatrix);

save simiMatrix -v7.3;