function [result_Ncut,sumtime_Ncut] = run_Ncut(X,Y)
tic
X = full(X);
% double£ºDouble precision array
X =(double(X));
num = size(X,1);
X = X-repmat(mean(X),[num,1]);
% X = U;
if min(Y) == 0 
Y = Y + 1;
end
inClusters = length(unique(Y));

    [S0, Sn0, L0, D0] = selftuning(X, 5);
    [Fnpk, D] = eig1(full(Sn0), inClusters, 1, 1);
    bestInd2 = kmeans(Fnpk,inClusters);
%    bestInd2 = kmeans_fastest(Fnpk',inClusters);
    result_Ncut = ClusteringMeasure(Y,bestInd2);
    sumtime_Ncut =  toc;
end
%{
tic
 X = M;
 Y = L;
X = full(X);
inClusters = length(unique(Y));
[nSample, nFeature] = size(X);

for jj = 1 : 100
	Ini(:, jj) = randsrc(nSample, 1, 1:inClusters);
end;

[S0 Sn0 L0 D0] = selftuning(X, 5);
D1 = diag(sum(S0,2));
[Fpk, D] = eig1(full(Sn0), inClusters, 1, 1);
bestInd2 = kmeans(Fpk,inClusters);
% bestInd2 = kmeans_fastest(Fpk',inClusters);
result_Ncut = ClusteringMeasure(Y,bestInd2);
    sumtime_Ncut =  toc;
end
%}




