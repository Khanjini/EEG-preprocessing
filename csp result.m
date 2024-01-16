f_name = sprintf('s%02d.mat',num);
load(f_name);

% Common Average Reference & bandpass filter
m_data_r = mean(eeg.imagery_right([1:64],:));
m_data_r = repmat(m_data_r,64,1);
data_r = eeg.imagery_right([1:64],:) - m_data_r;
bf_r = ft_preproc_bandpassfilter(data_r, eeg.srate, [8 30], 4, 'but');
pre_r = bf_r;

m_data_l = mean(eeg.imagery_left([1:64],:));
m_data_l = repmat(m_data_l,64,1);
data_l = eeg.imagery_left([1:64],:) - m_data_l;
data_l = eeg.imagery_left([1:64],:);
bf_l = ft_preproc_bandpassfilter(data_l, eeg.srate, [8 30], 4, 'but');
pre_l = bf_l;

%         data = cat(2,data_r,data_l);

%         data = data.* 524288/2^24; %gain value
%         bf = ft_preproc_bandpassfilter(data, eeg.srate, [8 30], 4, 'but');

%         pre_r = bf(:,[1:size(bf,2)/2]);
%         pre_l = bf(:,[size(bf,2)/2+1:size(bf,2)]);

n_trials = eeg.n_imagery_trials;
pre_r = pre_r(:,[1:srate*7*n_trials]);
pre_l = pre_l(:,[1:srate*7*n_trials]);

mi_length = 1026;
r_mi = zeros(size(pre_r,1),mi_length*n_trials);
l_mi = zeros(size(pre_r,1),mi_length*n_trials);

for t = 1:n_trials;
    r_mi(:,[1+mi_length*(t-1):mi_length*t]) = pre_r(:,[1024+floor(512*0.4)+3584*(t-1):2560-floor(512*0.6)+3584*(t-1)]);
    l_mi(:,[1+mi_length*(t-1):mi_length*t]) = pre_l(:,[1024+floor(512*0.4)+3584*(t-1):2560-floor(512*0.6)+3584*(t-1)]);
end;

r_mi = r_mi';
r_mi = reshape(r_mi,mi_length,size(pre_r,1),n_trials);
l_mi = l_mi';
l_mi = reshape(l_mi,mi_length,size(pre_r,1),n_trials);

accuracy = eval_csp_fldatest2(l_mi,r_mi, 5);
csp_result_max_mean_min_std2(num,:) = accuracy(1,:);
