function [result_LSCK,sumtime_LSCK,obj]  = run_LSCK(X,Y)
tic
% double£ºDouble precision array
X = full(X);
X =(double(X));
num = size(X,1);
X = X-repmat(mean(X),[num,1]);
if min(Y) == 0 
Y = Y + 1;
end
c = length(unique(Y));
opts.p = c*15;
fprintf('This is  LSCK \n');
res = LSC(X, c, opts);
% result_LSCK = ClusteringMeasure(Y,res);
result_LSCK = ClusteringMeasure_new(Y,res);
sumtime_LSCK = toc;
obj = 0;
end