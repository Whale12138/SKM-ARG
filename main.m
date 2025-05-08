% Sparse k-means clustering with anchro graph regularization
% min || x_i - v_k ||^2_{2}*y_ik + Lambda|| Y - BZ ||^2_{F}
% s.t. Y>=0,Y1=1,Z>=0,Z1=1,v_k
% solve:
%  Convergence experiment of the proposed method
% Input: data matrix X(n*d), label Y
% Output: Optimal convergence value
% 2024/05/01 vison 1.0  Weihao Zhao



%% 
clear;clc
close all
addpath('dataset')
addpath('funs')
addpath('run_funs')
% load data 
ds.data_file = 'segment_uni.mat';
% ds.data_file = 'MnistData_05_uni.mat';
% ds.data_file = 'MnistData_10_uni.mat';
% ds.data_file = 'USPSdata_uni.mat';
% ds.data_file = 'PenDigits.mat';
% ds.data_file = 'mnist_4w.mat';


load(ds.data_file);
fprintf('Run  %s \n', ds.data_file);

X = full(X);
c = length(unique(Y));
% mu = 0.1;
% rho = 1.1;
lamda = 1e1;
% Tuning parameters£º
rho = 1.1;
mu = 1e-3;
numAnchor = 256; % number of anchor 
numNearestAnchor = 8;

[result_SKM_AGR,time_SKM_AGR,obj_SKM_AGR] = run_AKM_AGR(X,Y,numAnchor,numNearestAnchor,mu,rho,lamda);


save segment_result.mat




