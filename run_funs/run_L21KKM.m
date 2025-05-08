function  [result_L21KKM,sumtime_L21KKM,obj_L21KKM] = run_L21KKM(X,Y,k)
tic
% X = full(X);
% X =(double(X));
num = size(X,1);
% X = X-repmat(mean(X),[num,1]);
inClusters = length(unique(Y));
% k = 8;
% Feiping Nie, Xiaoqian Wang, Michael I. Jordan, Heng Huang. The Constrained Laplacian Rank Algorithm for Graph-Based Clustering. The 30th AAAI Conference on Artificial Intelligence (AAAI), Phoenix, USA, 2016.
%[A ] =  ConstructA_NP1(X', X',k);
fprintf('This is  L21KKM \n');
%initialize the kernel
%K = A; %should be an N x N matrix containing similarity values between samples

options.KernelType = 'Gaussian';
options.t = 1000;
K = constructKernel(X,[],options);
[bestInd, center,~,sumD] =  L21KKM(K, inClusters);
obj_L21KKM = sum(sumD);
result_L21KKM = ClusteringMeasure_new(Y,bestInd);
sumtime_L21KKM = toc;
end