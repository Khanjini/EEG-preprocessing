function [W D]= CSP_unit_filter(covX1, covX2)
[W, D]=eig(covX2\covX1);
eigenvalues = diag(D);
[D egIndex] = sort(eigenvalues, 'ascend');
W = W(:,egIndex);


% cov_x1x2 = covX1 + covX2;
% 
% [EVec, EVal] = eig(cov_x1x2);
% [EVal, ind] = sort(diag(EVal), 'descend');
% EVec = EVec(:, ind);
% 
% Q = zeros(size(covX1,1),size(covX1,1));
% Q = sqrt(pinv(diag(EVal))) * EVec';
% 
% S1 = Q*covX1*Q';
% S2 = Q*covX2*Q';
% 
% [B, D] = eig(S1, S2);
% [D, ind] = sort(diag(D));
% B = B(:,ind);
% W = B'*Q;
