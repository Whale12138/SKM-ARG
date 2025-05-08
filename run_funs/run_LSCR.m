function [result_LSCR,sumtime_LSCR,obj]  = run_LSCR(X,Y)
tic
% full：Convert sparse matrix to full storage
X = full(X);
X =(double(X));
num = size(X,1);
X = X-repmat(mean(X),[num,1]);
if min(Y) == 0 
Y = Y + 1;
end
c = length(unique(Y));
opts.p = c*15;
opts.mode = 'random';%这是LSC-R
%把上一条注释，默认就是LSC-K
%Clustering using landmark-based spectral clustering
% rand('twister',5489) 
fprintf('This is  LSCR\n');
res = LSC(X, c, opts);
% result_LSCR = ClusteringMeasure(Y,res);
result_LSCR = ClusteringMeasure_new(Y,res);
sumtime_LSCR = toc;
obj = 0;
end
