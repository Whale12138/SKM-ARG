function [res_SKM_AGR,time_SKM_AGR,obj] = run_SKM_AGR(X,Y,numAnchor,numNearestAnchor,mu,rho,lamda)
% min || u_i - v_k ||^2_{2}*y_ik + Lambda|| Y - BZ ||^2_{F}
% s.t. Y>=0,Y1=1,Z>=0,Z1=1,v_k
% solve:
% 1: fix Y and Z, update V
% Differentiate v_k
% 2: fix V and Y, update Z 
% min trace(Z'AZ)-trace(Z'E)-mu/2|| Z - P - 1/mu*beta ||^2_{F}
% s.t. P>=0,Z1=1,Z=P
% 2.1: fix Z , update P 
% min || P - H ||^2_{F}
% s.t. P>=0
% 2.2: fix P , update Z  
% min || Z - K ||^2_{F}
% s.t. Z1=1
% 3: fix V and Z, update Y 
% min || u_i - v_k ||^2_{2}*y_ik + Lambda|| Y - BZ ||^2_{F}   
% >>  min || Y - U ||^2_{F}
% s.t. Y>=0,Y1=1,
% Input: data matrix X(n*d), label Y
% Output: clustering ACC, NMI, and purity
% Code introduction
% run_SKM_AGR is a main function
% FKMX is a sub-main function

tic
%% Initial value processing
c = length(unique(Y)); % Number of clusters
% Tuning parameters��
%numAnchor = c*15;
%numNearestAnchor = 5;
%mu = 1e-2;
%rho = 1.1;
%lamda = 0.1;
%% Initialize processing
[output,obj] = FKMX_iter(X,Y,c,numAnchor,numNearestAnchor,mu,rho,lamda);
res_SKM_AGR = ClusteringMeasure_new(Y,output);
time_SKM_AGR = toc;
