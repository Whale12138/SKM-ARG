function [result_FSC,time_FSC,obj] = run_FSC(X,Y,numAnchor,numNearestAnchor)
tic
% fprintf('Run FSC on %s \n', ds.data_file);
% load(ds.data_file);
% X = full(fea);
% Y = gnd;
% X = full(X);
% X =(double(X));
num = size(X,1);
% X = X-repmat(mean(X),[num,1]);
% if min(Y) == 0 
%     Y = Y + 1;
% end
% parameter setting %
% numNearestAnchor = 5;
c = length(unique(Y));
% numAnchor = c*15;

% obtain graph embedding data U %
[~, locAnchor] = kmeans(X, numAnchor,'MaxIter',10,'emptyaction','singleton');
Z = ConstructA_NP(X',locAnchor',numNearestAnchor);
Z = full(Z);
D_Z = diag((sum(Z,1)).^(-0.5));
Z1 = Z*D_Z;
SS1 = Z1'*Z1; 
[V, ev0, ev]=eig1(SS1,c);
U=(Z1*V)./(ones(num,1)*sqrt(ev0'));

y = kmeans(U,c);
result_FSC = ClusteringMeasure_new(Y,y);
time_FSC = toc;
obj = 0;
end