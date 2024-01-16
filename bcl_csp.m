function [W D]= bcl_csp(matrix1,matrix2)
%function W = csp(matrix1,matrix2)
%
% *** INPUT ***
% matrix1 : [channels x (time x trials)]
% matrix2 : [channels x (time x trials)]
% 
% *** OUTPUT ***
% W : weight matrix [channels x channels]
% 
% 
% *** USAGE ***
% function [W D] = csp(matrix1,matrix2) 
% 
% For Method 2, eig() used function
% W = csp(left, right) =>   W(:,last) is for left
%                           W(:,1) is for right
% *** MODIFICATION ***
% 
% 
%----------------------------------------------------------------
% Minkyu Ahn        frerap@gist.ac.kr
% http://biocomput.gist.ac.kr
%% Method 1
% covL=(matrix1*matrix1')/trace(matrix1*matrix1');
% covR=(matrix2*matrix2')/trace(matrix2*matrix2');
% 
% covRL=covR+covL;
% [U D V]=svd(covRL); % U = V
% 
% %whitening transformation
% % P=diag(sort((diag(D)).^-0.5,'descend'))*U';
%  P=diag(diag(D).^-0.5)*U';
% 
% 
% SL=P*covL*P';
% [u D v]=svd(SL);
% 
% 
% 
% %CSP pattern
% W=P'*u;


%% Method 2
%make csp filter
covL=(matrix1*matrix1');
covR=(matrix2*matrix2');

clear('matrix1','matrix2');

covRL = covR+covL;

% CSP Filters
[W, D]=eig(covL,covRL);
