%% For Cho et al. dataset
sub = num_sub;
f_name = sprintf('s%02d.mat',sub);
load(f_name);

rest_data = eeg.rest([1:64],[3*512+1:512*63]).* 524288/2^24; % resting-state data is extracted
rest_data = reshape(rest_data,[64,512,60]); % chans X the number of samples X trials

ft_form.label = chan_label;
ft_form.fsample = 512; % Sampling rate
ft_form.time = cell(1,size(rest_data,3));
ft_form.trial = cell(1,size(rest_data,3));
ft_form.trialinfo = zeros(size(rest_data,3),1);
time = linspace(0,1,1*512);

for i = 1:size(ft_form.trial,2);
    ft_form.time{1,i} = [time];
    ft_form.trial{1,i} = [rest_data(:,:,i)];
end

f_name = sprintf('ft_rest_%02d.mat',sub);
save(f_name,'ft_form');

%% For Lee et al. dataset

chan_nums = [4,33,35,13,39,24,29,14,6,34,15,38,41,26,31];
chan_label = {'F3','FC3','C5','C3','CP3','P3','O1','Cz','F4','FC4','C4','C6','CP4','P4','O2'};

num = num_sub;

l_name = sprintf('sess02_subj%02d_EEG_MI.mat',num);
load(l_name);

data = EEG_MI_train.pre_rest(:,chan_nums);
data = downsample(data,2)';

rest_data = data.* 524288/2^24;
rest_data = single(rest_data);

rest_data = reshape(rest_data,[size(rest_data,1),500,60]);

ft_form.label = chan_label;
ft_form.fsample = 500;
ft_form.time = cell(1,size(rest_data,3));
ft_form.trial = cell(1,size(rest_data,3));
ft_form.trialinfo = zeros(size(rest_data,3),1);
time = linspace(0,1,1*500);

for i = 1:size(ft_form.trial,2);
    ft_form.time{1,i} = [time];
    ft_form.trial{1,i} = [rest_data(:,:,i)];
end

f_name = sprintf('ft_Lee_%02d.mat',num);
save(['C:\Users\Biocomputing\Desktop\workplace\korea_mi\rest_ft2\' f_name],'ft_form');
