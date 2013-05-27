%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Find image pairs according to keyword similarity
%
% Note: Usually the number of dissimilar pairs is much larger than that of 
% similar pairs. Need to find a good balance. In this implementation, we go
% through all images to discover all similar pairs, but only generate part
% of dissimilar pairs.
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function GetLassoImagePairs = GetLassoImagePairs()
clear;
load('keywords');
load('imagelist');
pid = 1;
nid = 1;
positivePairs = zeros(80000, 2);
negativePairs = zeros(90000, 2);
for i=1:size(keywords, 1)
    kwsrc = keywords(i,:);
    kwsrc = kwsrc(find(kwsrc ~= 0));
    for j=1:size(keywords, 1)
        if i==j
            continue;
        end
        kwtar = keywords(j,:);
        kwtar = kwtar(find(kwtar ~= 0));
        % similar pairs if two images share more than 3 keywords
        if numel(intersect(kwsrc, kwtar))>=3 
            positivePairs(pid,1) = i;
            positivePairs(pid,2) = j;
            pid = pid + 1;
        end
    end
end

% only go through some images to generate dissimilar pairs
testidx = randperm(100);
testidx = testidx(1:8);
testidx = ones(50,1)*testidx;
scale = 0:100:4999;
scale = ones(8,1)*scale;
testidx = testidx + scale';
idx = find(testidx == 5000);
testidx(idx) = 4999;
for i=1:numel(testidx)
    kwsrc = keywords(testidx(i),:);
    kwsrc = kwsrc(find(kwsrc~=0));
    for j=1:numel(testidx)
        kwtar = keywords(testidx(j),:);
        kwtar = kwtar(find(kwtar~=0));
        % dissimilar image pairs if two images share no common keywords
        if (numel(intersect(kwsrc, kwtar))==0)
            negativePairs(nid,1) = testidx(i);
            negativePairs(nid,2) = testidx(j);
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

save('positivePairs_keywords','positivePairs');
save('negativePairs_keywords','negativePairs');