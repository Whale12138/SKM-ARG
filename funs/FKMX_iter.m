function [output,obj] = FKMX_iter(X,Y,c,numAnchor,numNearestAnchor,mu,rho,lamda)
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
% 2023/8/15 vison 5.0 Whale

%% Initial value processing
num = size(X,1);
NITER = 30; % number of iterative
opt_value1 = 0; %Iterative convergence value
val_old = 0;    %Iterative convergence value of Z
iter1 = 30; % Z: number of iterative

%% Initialize processing
% [~, locAnchor]=litekmeans(X, numAnchor,'MaxIter',5,'Replicates',1);
[~, locAnchor] = litekmeans(X, numAnchor,'MaxIter',10);
% construct anchor graph B
B = ConstructA_NP(X',locAnchor',numNearestAnchor);
A = B'*B;
% Random initialization matrix Z
%{
Z = constructZ_PKN(X,Anchor,numNearestAnchor);
%}
Z = rand(numAnchor,c);
rowsum = sum(Z,2);
Z = bsxfun(@rdivide, Z, rowsum);
% Initialize matrix V and Y
%[~, V] = kmeans(X, c,'MaxIter',10,'emptyaction','singleton');
%[~, V] = litekmeans(X, c,'MaxIter',10);
%Y1 = ConstructA_NP(X',V',c-1);
U = initfcm(c, num);
Y1 = U'; 
Lambda = zeros(numAnchor,c);
P = zeros(numAnchor,c);

%% iteration processing 
for iter = 1:NITER
%fix Y and Z, update V
    Y_sum = sum(Y1);
    for i = 1:c
        V(i,:) = sum(X.*Y1(:,i))/Y_sum(i);
    end
%fix V and Y, update Z 
for it = 1 : iter1          
        E = 2*B'*Y1;
    %fix Z , update P 
    % s.t. P>=0
        G = Z+1/mu*(Lambda-A'*Z);   
        I = find(G>0);
        P(I) = G(I);
    %fix P , update Z 
        K = P-1/mu*(Lambda+A*P-E);
        for i = 1:numAnchor
            Z(i,:) = EProjSimplex_new(K(i,:));
        end   
        %Iterative change
	val = 0;
       val = norm(Y1-B*Z,'fro');
       if abs(val-val_old)/abs(val_old) < 1e-6
           break;
        end
        val_old = val;
    % Update Lambda
        h = Z-P;
        Lambda = Lambda+mu*h;     
    % Update mu
        mu = rho*mu;
    end
%% fix V and Z, update Y   
    D = L2_distance(X',V');
    B_update = B*Z;
%{%}
    AD = B_update-1/2*lamda*D;
    for i = 1:num
      Y1(i,:) = EProjSimplex_new(AD(i,:));
    end

    % objective function
     obj = 0;
     T1 = Y1- B * Z;
    obj = trace(Y1'*D)+lamda*trace(T1'*T1);
    Tobj(iter) = obj;

    % convergence checking
    if iter>1
        temp_obj = Tobj(iter -1);
    else
        temp_obj = 0;
    end
    if abs(obj - temp_obj)/temp_obj <1e-6
        break;
    end
end
%plot(Tobj)
obj = Tobj(iter);

%% Clustering Measure
[~,output] = max(Y1,[],2);
