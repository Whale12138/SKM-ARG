function  [result_kmeans,sumtime_kmeans,obj_Gkmeans] = run_GKmeans(X,Y)
tic
% fprintf('Run Global K-means Clustering on %s \n', ds.data_file);
% load(ds.data_file);
X = full(X);
X =(double(X));
num = size(X,1);
% X = X-repmat(mean(X),[num,1]);
inClusters = length(unique(Y));
bucket_count = ceil(size(X,1)/15);
[bestInd,minDist] = fastKmeansClustering_kd(X,inClusters,bucket_count,Y);
obj_Gkmeans = sum(minDist);
% bestInd = fastKmeansClustering(X,inClusters);
result_kmeans = ClusteringMeasure_new(Y,bestInd);
sumtime_kmeans = toc; 
end




