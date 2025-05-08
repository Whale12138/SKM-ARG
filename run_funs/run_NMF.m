function [result_NMF,sumtime_NMF] = run_NMF(X,Y)
tic
% double£ºDouble precision array
X = full(X);
X =(double(X));
num = size(X,1);
X = X-repmat(mean(X),[num,1]);
if min(Y) == 0 
Y = Y + 1;
end
inClusters = length(unique(Y));
fprintf('NMF using pk\n');

[S0, Sn0, L0, D0] = selftuning(X, 5);
[Fnpk, D] = eig1(full(Sn0), inClusters, 1, 1);
n = size(Sn0, 1);
In = eye(n);
[Ind obj orobj objhard] = NMFdiscrete_one(Fnpk, Sn0, In);
result_NMF = ClusteringMeasure(Y,Ind);
sumtime_NMF = toc;
end

