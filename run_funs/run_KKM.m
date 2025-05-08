function  [result_KKM,sumtime_KKM,obj_KKM] = run_KKM(X,Y,k)
tic
% fprintf('Run KKM on %s \n', ds.data_file);
X = full(X);
X =(double(X));
num = size(X,1);
%s = struct('options','PolyPlus');
X = X-repmat(mean(X),[num,1]);
inClusters = length(unique(Y));
% k = 7;
% Feiping Nie, Xiaoqian Wang, Michael I. Jordan, Heng Huang. The Constrained Laplacian Rank Algorithm for Graph-Based Clustering. The 30th AAAI Conference on Artificial Intelligence (AAAI), Phoenix, USA, 2016.
% [A ] =  ConstructA_NP1(X', X',k);
 %K = constructKernel(X,[],s);
%initialize the kernel
% K = A; %should be an N x N matrix containing similarity values between samples
options.KernelType = 'Gaussian';
options.t = 1000;
K = constructKernel(X,[],options);
fprintf('This is  KKM \n');

%bestInd =  KernelKmeans(K, inClusters);
%result_KKM = ClusteringMeasure(Y,bestInd);
 [label, center,~,sumD,D] =  KernelKmeans(K, inClusters);
obj_KKM = sum(D(:));
result_KKM = ClusteringMeasure_new(Y,label);
sumtime_KKM = toc;
end