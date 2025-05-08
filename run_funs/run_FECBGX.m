 function [result_FECBGX,sumtime_FECBGX] = run_FECBGX(X,Y)
tic
X = full(X);
X =(double(X));
num = size(X,1);
X = X-repmat(mean(X),[num,1]);
if min(Y) == 0 
    Y = Y + 1;
end
iter = 50;
lamda = 0.1;
lamda2 = 0.1;
numNearestAnchor = 6;
c = length(unique(Y));
% numAnchor = c*15;
result_20 = zeros(6,3);
% result_object_function = zeros(5,1);
fprintf('This is  FECBGX \n');
% aa = [5,10,15,20,25,30];
aa = [2,4,6,8,10,12];
% obtain graph embedding data U 
for ni = 1:6
numAnchor = c*aa(ni);
time1 = toc;
sumtime_FECBGX(:,1) = time1;
tic
[~, U1] = kmeans(X, numAnchor,'MaxIter',10,'emptyaction','singleton');
Z2 = ConstructA_NP(X',U1',numNearestAnchor);
time2 = toc; 
sumtime_FECBGX(:,2) = time2;
tic
[~, U2] = kmeans(X, c,'MaxIter',10,'emptyaction','singleton');
Y1 = ConstructA_NP(X',U2',c-1);
M = U2;
time3 = toc;
sumtime_FECBGX(:,3) = time3;
tic
% iteration processing %
opt_value1 = 0;
for it = 1:iter
% fix Y and Z, update M
    Y_sum = sum(Y1);
    for i = 1:c
        M(i,:) = sum(X .* Y1(:,i))/Y_sum(i);
    end
time4 = toc;
sumtime_FECBGX(:,4) = time4;
tic
%fix M and Y, update Z 
A = (Z2'*Z2+1e-6*eye(numAnchor))\Z2'*Y1;
time5 = toc;
sumtime_FECBGX(:,5) = time5;
tic
%fix Z and M, update Y
 D = L2_distance_11(X',M');
 Y1_1 =((2*lamda*Z2*A+4*lamda2*Y1)./(D+2*lamda*Y1+4*lamda2*Y1));
 Y1  = Y1 .* Y1_1;
 Y1 = full(Y1);
 Y1 = Y1./sum(Y1,2);
    Y1 = abs(Y1);
    T = Y1 - Z2*A;
    opt_value = trace(Y1'*D)+lamda*trace(T'*T);
    tem = abs(opt_value - opt_value1)/abs(opt_value1);
    if tem <= 1e-03
        break;
    end
    opt_value1 = opt_value;
    result_object_function(it) = opt_value;
end
F = Y1*diag(sum(Y1).^-1);
[~,output] = max(F,[],2);
result_FECBGX = ClusteringMeasure(Y,output);
time6 = toc;
sumtime_FECBGX(:,6) = time6;
result_20(ni,:) = result_FECBGX; 
sumtime_FECBGX(:,7) = time1 + time2 + time3+ time4 + time5+ time6;
%sumtime_FECBGX =sumtime_FECBGX/length(unique(aa));
end
result_20
end
