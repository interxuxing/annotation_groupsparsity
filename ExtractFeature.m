%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description: Extract features (histogram) from single image
% To find saliency, check out this paper for reference:
% Xiaodi Hou, Liqing Zhang: Saliency Detection: A Spectral Residual
% Approach. CVPR 2007
%
% Author: Shaoting Zhang, shaoting@cs.rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function feature = ExtractFeature(img, idx, ...
    SALIENCY, ...
    RGB, OPP, rg, HSV, LAB)

feature = idx;

%% Saliency extracting
if(SALIENCY == 1)
    % Read image from file
    inImg = im2double(rgb2gray(img));
    oriSize = size(inImg);
    inImg = imresize(inImg, [64, 64], 'bilinear');
    % Spectral Residual
    myFFT = fft2(inImg);
    myLogAmplitude = log(abs(myFFT));
    myPhase = angle(myFFT);
    mySpectralResidual = myLogAmplitude - imfilter(myLogAmplitude, fspecial('average', 3), 'replicate');
    saliencyMap = abs(ifft2(exp(mySpectralResidual + j*myPhase))).^2;
    % After Effect
    saliencyMap = imfilter(saliencyMap, fspecial('disk', 3));
    saliencyMap = mat2gray(saliencyMap);
    saliencyMap = imresize(saliencyMap, oriSize, 'bilinear');
    % New saliency image's idx, salID
    mapTmp = reshape(saliencyMap, [1, numel(saliencyMap)]);
    salID = find(mapTmp > (mean(mapTmp) + std(mapTmp))); 
end

%% Color information: RGB, HSV, LAB
if(RGB == 1 || OPP == 1 || rg == 1 || HSV == 1 || LAB ==1 )
    bin = 16;
    maxi = 255;
    mini = 0;     
    curImg = img;
    if(HSV == 1)
        curImg = rgb2hsv(img);
        maxi = 1;
        mini = 0;
    elseif(LAB == 1)
        cform2lab = makecform('srgb2lab');
        curImg = applycform(img, cform2lab);
    elseif(OPP == 1 || rg == 1 || TRANS == 1)
        R = double(curImg(:,:,1));
        G = double(curImg(:,:,2));
        B = double(curImg(:,:,3));
        curImg = double(curImg);
        if OPP == 1
            maxi = 440;
            mini = -200;
            bin = 64;
            curImg(:,:,1) = (R-G)/sqrt(2);
            curImg(:,:,2) = (R+G-2*B)/sqrt(6);
            curImg(:,:,3) = (R+G+B)/sqrt(3);
        elseif rg == 1
            maxi = 1;
            mini = 0;
            bin = 64;
            curImg(:,:,1) = R./(R+G+B);
            curImg(:,:,2) = G./(R+G+B);
            curImg(:,:,3) = curImg(:,:,3).*0;
        end
    end
    for i=1:size(img,3)
        imgTmp = curImg(:,:,i);
        imgReshape = reshape(imgTmp, [1, numel(imgTmp)]);
        if(SALIENCY == 1)
            featureTmp = hist(imgReshape(salID), mini+(maxi-mini)/(2*bin) : (maxi-mini)/bin : maxi-(maxi-mini)/(2*bin));            
        else
            featureTmp = hist(imgReshape, mini+(maxi-mini)/(2*bin) : (maxi-mini)/bin : maxi-(maxi-mini)/(2*bin)); 
        end
        featureTmp = featureTmp/sum(featureTmp);
        feature = [feature, featureTmp];
    end
end