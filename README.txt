This package includes feature extraction, annotation evaluation, searching of similar pairs,
different distance metric, and weight computation from different regularization methods.
It's for Corel5K only. Image dataset is available upon request (about 80Mb). 

Many other code is written in C++ and maintained by my colleagues. It will be released later.
But this package contains essential code to evaluate annotation performance and regularization,

------------------------- CODE ----------------------------

0. Test: Script to test the annotation performance of all testing cases

1. ExtractFeatures and ExtractFeature: extract basic color features as histogram. C++ and 
Matlab Code extracting other features (texture, appearance, etc) is maintained by my colleagues 
and will be released in the future. That code is generally based on the following implementations:
http://staff.science.uva.nl/~ksande/research/colordescriptors/
http://www.robots.ox.ac.uk/~vgg/research/caltech/phog.html
but with many techniques to boost the performance.

2. Get***Weights: Compute weights from L2 regularization (Ridge regression), L1 regularization
(LASSO) and group sparsity (group LASSO). Solvers are from:
http://www.cs.ubc.ca/~schmidtm/Software/lasso.html (LASSO)
http://www.cs.ubc.ca/~murphyk/Software/L1CRF/index.html (group LASSO, need to download)

3. Get***Dist: different distance metric, such as L1, L2, KL-divergence, CHI square, etc.

4. evalRetrieval: evaluate annotation performance (average precision and recall)

5. ComputeSimilarity: Compute weighted distance and then convert to similarity measurement

6. LassoShooting and process_options: LASSO solver, from UBC

7. JEC: use equal weights to combine different feature vectors (need to be normalized)

8. Histogram2SimilarityMatrix and JEC_SimMat: convert histogram to similarity matrix. It's not
used in this package, but may still be useful since similarity matrix is very important for 
image retrieval and other applications.

9. GetLassoImagePairsFromDist and GetLassoImagePairsFromKeywords: find image pairs using two
different methods (solely rely on keyword similarity or also consider feature distance).

------------------------- DATA ----------------------------
1. imagelist: one-to-one correspondence between image IDs and images.

2. keywords and words: keyword ID for each image, and its corresponding text word.

3. testidx: image IDs of testing cases

4. positivePairs and negativePairs: similar and dissimilar pairs

5. Features: 10 different features (color histogram)












