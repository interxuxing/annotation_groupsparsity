function csDistance = GetchiSquareDist(his1,his2_all)

% his1 is a histogram 1xn
% his2_all is a group of histograms, kxn

[k_his,n_dim]=size(his2_all);

his1_all = ones(k_his,1)*his1;

temp_matrix = ((his1_all==0).*(his2_all==0));

his1_all = his1_all + temp_matrix;
his2_all = his2_all + temp_matrix;

temp = (his1_all-his2_all).^2./(his1_all+his2_all);

csDistance = sum(temp,2);