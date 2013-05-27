%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Find image pairs according to keyword similarity and feature
% distance. First find candidates of similar/dissimilar image pairs
% according to feature distance, then prune them according to keyword
% similarity (or catogery information).
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function GetLassoImagePairsFromDist = GetLassoImagePairsFromDist()
clear;
load('keywords');
load('imagelist');

idFea = 1;
load('rgb16');Fea{idFea}=features;FeaName{idFea}='rgb';idFea=idFea+1;
load('rgb16saliency');Fea{idFea}=features;FeaName{idFea}='rgbsal';idFea=idFea+1;
load('hsv16');Fea{idFea}=features;FeaName{idFea}='hsv';idFea=idFea+1;
load('hsv16saliency');Fea{idFea}=features;FeaName{idFea}='hsvsal';idFea=idFea+1;
load('lab16');Fea{idFea}=features;FeaName{idFea}='lab';idFea=idFea+1;
load('lab16saliency');Fea{idFea}=features;FeaName{idFea}='labsal';idFea=idFea+1;
load('opp64');Fea{idFea}=features;FeaName{idFea}='opp';idFea=idFea+1;
load('opp64sal');Fea{idFea}=features;FeaName{idFea}='oppsal';idFea=idFea+1;
load('rg64');Fea{idFea}=features;FeaName{idFea}='rg';idFea=idFea+1;
load('rg64sal');Fea{idFea}=features;FeaName{idFea}='rgsal';idFea=idFea+1;

for i=1:size(Fea,2)
    FeaMat = Fea{i};
    minFea = min(FeaMat);
    maxFea = max(FeaMat);
    maxDist = maxFea - minFea;
    alpha(i) = sum(maxDist(:,2:size(FeaMat,2)));
end

pid = 1;
nid = 1;
positivePairs = zeros(200000, 2);
negativePairs = zeros(200000, 2);
knnP = 110;
knnN = 25;
for i=1:size(keywords, 1)
    kwsrc = keywords(i,:);
    kwsrc = kwsrc(find(kwsrc ~= 0));
    dist = zeros(size(features,1), 1);
    for j=1:size(Fea,2)
        features = Fea{j};
        test = features(i,2:size(features,2));
        testVec = ones(size(features,1),1) * test;
        distVec = abs(features(:,2:size(features,2)) - testVec);
        dist = dist + sum(distVec, 2) / alpha(j);
    end
    distTmp = sort(dist);
    distTmp = distTmp(1:knnP);
    for j=1:knnP
        id = find(dist == distTmp(j));
        kwtag = keywords(id(1),:);
        kwtag = kwtag(find(kwtag ~= 0));        
        % similar pairs
        if (numel(intersect(kwtag, kwsrc)) > 3) || (numel(intersect(kwtag, kwsrc))/numel(kwsrc) >= 0.66 || (numel(intersect(kwtag, kwsrc))/numel(kwtag) >= 0.66))  && (id(1) ~= i)
            positivePairs(pid,:) = [i,id(1)];
            pid = pid + 1;
        end
    end
    distTmp = sort(dist,'descend');
    distTmp = distTmp(1:knnN);
    for j=1:knnN
        id = find(dist == distTmp(j));
        % dissimilar pairs
        if (numel(intersect(kwtag, kwsrc) == 0)) && (id(1) ~= i)
            negativePairs(nid,:) = [i,id(1)];
            nid = nid + 1;
        end
    end
end

[i,j] = find(positivePairs~=0);
i = max(i);
positivePairs = positivePairs(1:i,:);
[i,j] = find(negativePairs~=0);
i = max(i);
negativePairs = negativePairs(1:i,:);
save('positivePairs','positivePairs');
save('negativePairs','negativePairs');