function [prec,rec] = evalRetrieval( wPred, wTrue )
%
% [prec,rec] = evalRetrieval( wPred, wTrue )
% 
% Precision and recall scores for image annotation problem.
% Input:
%   wPred:   a Ndict x Nsample matrix of predicted indicators.
%            Entry wPred(i,j) is 1 iff j-th image is annotated
%            with keyword i.
%   wTrue:   a Ndict x Nsample matrix of true indicators. Same
%            structure as wPred.
%
% Output:
%   prec:    precision vector, per keyword.
%   rec:     recall vector, per keyword.
%
% Note:
%   One typically reports average precision and recall, mean(prec)
%   and mean(rec), or average scores for retreived keywords, 
%   mean(prec(rec>0)) and mean(rec(rec>0)).
%

% Compute performance scores
hit  = sum(wPred.*wTrue,2);
pred = sum(wPred,2);
true = sum(wTrue,2);

prec = hit ./ (pred+eps);
rec  = hit ./ (true+eps);
