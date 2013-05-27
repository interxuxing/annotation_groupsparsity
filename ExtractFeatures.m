%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Extract features (histogram) from all images in rootDir
%
% Usage: need to change rootDir and parameters for ExtractFeature
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function features = ExtractFeatures()

clear;

features = [];
rootDir = ls('eccv_2002_image_files\');
for idx=3:size(rootDir)
    nameidx = find(rootDir(idx,:)==' ');
    if(size(nameidx)>0)
        rootTmp = rootDir(idx,1:nameidx(1)-1);
    else
        rootTmp = rootDir(idx,:);        
    end
    subDir = ls(['eccv_2002_image_files\',rootTmp]);    
    for jdx=3:size(subDir)
        curImg = imread(['eccv_2002_image_files\', ...
            rootTmp, '\', subDir(jdx,:)]);
        % features will be extracted separately, thus only one of rgb, hsv,
        % lab, gabor, haar and haarq can be 1, the other values should be 0
        % saliency equals to one means extract feature from saliency.
        feature = ExtractFeature(curImg, idx, ...
            1, ...          % saliency
            0, 1, 0, ...    % rgb, opp, rg
            0, 0); % hsv, lab
        features = [features; feature];
    end
end
% Change the name for saving
save opp64sal features;