function [result_RSFKM,sumtime_RSFKM,obj_RSFKM] = run_RSFKM(X,Y,gamma)

tic
%% Initialize processing
fprintf('This is  RSFKM \n');
[output,obj_RSFKM] = RSFKM1(X,Y,gamma);
result_RSFKM = ClusteringMeasure_new(Y,output);
sumtime_RSFKM = toc;