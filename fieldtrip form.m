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
