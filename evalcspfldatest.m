function accuracy = evalcspfldatest( train_x1, train_x2, n_filter)
% function accuracy = evalfldatest(train_x1, train_x2, opt)
% 
% *** INPUT ***
% train_x1    : [times  x  channels  x  trials ] belonging to class 1
% train_x2    : [times  x  channels  x  trials ] belonging to class 2
% method      : method='leave' -> leave one out method
%               method='cross' -> cross validation method
%
% opt         : if opt = 'msgon' then message printed
% 
% 
% *** OUTPUT ***
% accuracy      : [max mean min std] of accuracy
% 
% 
% *** USAGE ***
% accuracy = evalfldatest(train_x1, train_x2)
% 
% 
% 
% *** FUNC. NEEDED ***
% - fldatest() in BCL LIB.
% 
% 
% 
% *** MODIFICATION ***
% 2010.08.16 : Minkyu Ahn
% - first written
% 2010.08.17 : Minkyu Ahn
% - Cross validation method added
% 2010.08.20 : Hohyun Cho
% - evalfldatest -> evalcspfldatest
% 2010.09.09 : Hohyun Cho
% - mean zero for each test trial
% 2010.09.09 : Hohyun Cho
% - mean zero using training data's mean
%--------------------------------------------------------------------------
% Minkyu Ahn        frerap@gist.ac.kr
% Hohyun Cho        augustcho@gist.ac.kr
% http://biocomput.gist.ac.kr

%% Pre processing
n_train_trials = [size(train_x1,3), size(train_x2,3)];
train_accuracy = [];
test_accuracy = [];

tmp_acc = [];
   
%% Cross Validation Method : 10set -> 3(test) : 7(train), 120 iterations

msg('Running Cross Validation Method');

% Make sub dataset index
p = floor(n_train_trials / 10);

isubset_x1=[]; isubset_x2=[]; 
for i=1:9
    isubset_x1 = [isubset_x1; (i-1)*p(1)+1  i*p(1)];
    isubset_x2 = [isubset_x2; (i-1)*p(2)+1  i*p(2)];
end
isubset_x1 = [isubset_x1; 9*p(1)+1  n_train_trials(1)];
isubset_x2 = [isubset_x2; 9*p(2)+1  n_train_trials(2)];

% Start Iteration to check performance
sequence = nchoosek([1:10],3);

FeatureValues_x1 = [];
FeatureValues_x2 = [];
for it=1:size(sequence,1)
    % Get trial index for train and test data set for each class
    [itr_train_x1 itr_test_x1]=GetIndex(sequence(it,:), isubset_x1);
    [itr_train_x2 itr_test_x2]=GetIndex(sequence(it,:), isubset_x2);

    % Separate data set into train and test set
    tmp_train_x1 = train_x1(:,:,itr_train_x1);
    tmp_test_x1 = train_x1(:,:,itr_test_x1);

    tmp_train_x2 = train_x2(:,:,itr_train_x2);
    tmp_test_x2 = train_x2(:,:,itr_test_x2);

    % reform data: 3D -> 2D
    n_train_trials = [size(tmp_train_x1,3), size(tmp_train_x1,3)];
    n_test_trials = [size(tmp_test_x1,3), size(tmp_test_x2,3)];

    n_train_samples = size(train_x1,1);
    n_test_samples = size(train_x1,1);

    tmp_train_x1 = reformsig(tmp_train_x1);
    tmp_train_x2 = reformsig(tmp_train_x2);
    tmp_test_x1 = reformsig(tmp_test_x1);
    tmp_test_x2 = reformsig(tmp_test_x2);

    tmp_train_x1 = tmp_train_x1';
    tmp_train_x2 = tmp_train_x2';
    tmp_test_x1 = tmp_test_x1';
    tmp_test_x2 = tmp_test_x2';

    % class1, class2 CSP
    [W]= bcl_csp(tmp_train_x1,tmp_train_x2);
    n_channels = size(tmp_train_x1,1);
    n_trials = n_train_trials + n_test_trials;

    csp_pat=[1:n_filter  n_channels-(n_filter-1):n_channels]; %selection of W

    % feature extraction
    train_x1_feat=zeros(length(csp_pat),n_train_trials(1));
    train_x2_feat=zeros(length(csp_pat),n_train_trials(2));

    test_x1_feat=zeros(length(csp_pat),n_test_trials(1));
    test_x2_feat=zeros(length(csp_pat),n_test_trials(1));

    temp=zeros(length(csp_pat),1);
    temp1=zeros(length(csp_pat),1);

    for i=1:n_train_trials(1) 
        x1_train=tmp_train_x1(:,(i-1)*n_train_samples+1:i*n_train_samples);
        x2_train=tmp_train_x2(:,(i-1)*n_train_samples+1:i*n_train_samples);

        for j=1:length(csp_pat)
            temp(j)= log(W(:,csp_pat(j))'*x1_train*x1_train'*W(:,csp_pat(j)));
            temp1(j)= log(W(:,csp_pat(j))'*x2_train*x2_train'*W(:,csp_pat(j)));
        end
        x1_train_feat(:,i)=temp;
        x2_train_feat(:,i)=temp1;
    end

    temp=zeros(length(csp_pat),1);
    temp1=zeros(length(csp_pat),1);

    for i=1:n_test_trials(1) 
        x1_test=tmp_test_x1(:,(i-1)*n_test_samples+1:i*n_test_samples);
        x2_test=tmp_test_x2(:,(i-1)*n_test_samples+1:i*n_test_samples);
        for j=1:length(csp_pat)
            temp(j)= log(W(:,csp_pat(:,j))'*x1_test*x1_test'*W(:,csp_pat(:,j)));
            temp1(j)= log(W(:,csp_pat(:,j))'*x2_test*x2_test'*W(:,csp_pat(:,j)));
        end
        x1_test_feat(:,i)=temp;
        x2_test_feat(:,i)=temp1;
    end

    % Calculate accuracy using fldatest()
    [acc_test, acc_train, w, w0] = fldatest( x1_train_feat, x2_train_feat, x1_test_feat, x2_test_feat);
    acc_test.W = W;
    tmp_acc = [tmp_acc;  acc_test ];
    if (exist('opt','var') & strcmp(opt,'msgon'))
        msg(['iteration: ' num2str(it) '/' num2str(size(sequence,1)) '  test accuracy = ' num2str(acc_test.accuracy)]);
    end
end 
accuracy = tmp_acc;

% sub function for Cross Validation Method
% generate test trial and train trial index
function [itr_train itr_test]=GetIndex(iset, isubset)
    itr_test=[];
    itr_train=[1:isubset(10,2)];

    for i=3:-1:1
        idx = [isubset(iset(i),1) : isubset(iset(i),2)];
        itr_test = [itr_test, idx];
        itr_train(idx)=[];
    end
    itr_test = sort(itr_test);
	itr_train = sort(itr_train);
    
%% SUB FUNCTION
function msg(str)
disp(['evalcspfldatest(): ' str]);
