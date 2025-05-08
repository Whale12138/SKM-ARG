function  [result_KMM,sumtime_KMM] = run_KMM(X,Y,k)
%K-Multiple-Means (KMM)
tic
% fprintf('Run KMM on %s \n', ds.data_file);
% X = full(X);
% X =(double(X));
num = size(X,1);
% X = X-repmat(mean(X),[num,1]);
inClusters = length(unique(Y));
m=floor(sqrt(num*inClusters));
% k=5;
fprintf('This is  KMM \n');
% bestInd =  kmeans(X,inClusters);
[laKMM,~,~,A,~,Ah,laKMMh ]= KMM(X', inClusters, m,k) ;
result_KMM = ClusteringMeasure_new(Y, laKMM);
sumtime_KMM = toc;
end