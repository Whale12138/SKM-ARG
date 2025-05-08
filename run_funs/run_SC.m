function [result_SC,sumtime_SC]  = run_SC(X,Y)
tic
X = full(X);
% double£ºDouble precision array
X =(double(X));
num = size(X,1);
inClusters = length(unique(Y));

[S0, Sn0, L0, D0] = selftuning(X, 5);
fprintf('This is  SC\n');
D1 = diag(sum(S0,2));
[Fpk, D] = eig1(full(D1-S0), inClusters, 0, 1);
bestInd = kmeans(Fpk,inClusters);
result_SC = ClusteringMeasure(Y,bestInd);
%{
[Ini,inG0] = InitializeG(num,inClusters );
A = selftuning(X,5);
Ds = diag(sum(A,2).^(-0.5));
As = Ds*A*Ds;
[F, ~, ~] = svds(As,inClusters);
F = diag(diag(F*F').^(-1/2))*F;
resall = kmeans_ldj(F,Ini);
result_SC = ClusteringMeasure(Y,resall);
%}

sumtime_SC = toc;
end