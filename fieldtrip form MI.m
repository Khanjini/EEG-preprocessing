%% right_mi
num = 2;
f_name = sprintf('s%02d.mat',num);
load(f_name);
win_len=diff(eeg.frame)/1000; % window length(s)/5s
sample_ep_len = win_len * eeg.srate; %total # of samples in one trial
imgr_data = eeg.imagery_right(1:64,:);

for i  = 1 : size(eeg.imagery_right,2)/sample_ep_len;
    s02_imgr_data(:,:,i) = imgr_data(:,[1:3584]+sample_ep_len*(i-1));
end

s02_imgr.label = chan_label;
s02_imgr.fsample = 512;
s02_imgr.time = cell(1,100);
s02_imgr.trial = cell(1,100);
s02_imgr.trialinfo = zeros(100,1); %right = 0 , left = 1
time = linspace(-2,5,7*512);

for i = 1:size(s02_imgr.trial,2);
    s02_imgr.time{1,i} = [time];
    s02_imgr.trial{1,i} = [s02_imgr_data(:,:,i)];
end

%% left_mi

num = 2;
f_name = sprintf('s%02d.mat',num);
load(f_name);
win_len=diff(eeg.frame)/1000; % window length(s)/5s
sample_ep_len = win_len * eeg.srate;
imgl_data = eeg.imagery_left(1:64,:);

for i  = 1 : size(eeg.imagery_left,2)/sample_ep_len;
    s02_imgl_data(:,:,i) = imgl_data(:,[1:3584]+sample_ep_len*(i-1));
end

s02_imgl.label = chan_label;
s02_imgl.fsample = 512;
s02_imgl.time = cell(1,100);
s02_imgl.trial = cell(1,100);
s02_imgl.trialinfo = ones(100,1); %right = 0 , left = 1
time = linspace(-2,5,7*512);

for i = 1:size(s02_imgl.trial);
    s02_imgl.time{1,i} = [time];
    s02_imgl.trialinfo(i,1) = 1; %right = 0 , left = 1
    s02_imgl.trial{1,i} = [s02_imgl_data(:,:,i)];
end
