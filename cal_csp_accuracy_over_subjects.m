fpath = '..\';
freq = [8 30];
frame = [400 2400];

for is=11:20
    
    sub = ['s' num2str(is)];
    showtime(sub);
    
    fname = [fpath sub '000.mat'];
    clear eeg;
    load(fname);
   
      
    % Re referencing
    disp([sub '- Re referencing']);
    rleft = mean(eeg.raw_left);
    rleft = repmat(rleft,64,1);
    
    left = eeg.raw_left - rleft;

	rright = mean(eeg.raw_right);
    rright = repmat(rright,64,1);
    
    right = eeg.raw_right - rright;
    
    % Baseline correction
    left = baselineCorS(left);
    right = baselineCorS(right);
    

    % Filtering separately
    disp(['Filtering with ' num2str(freq) 'Hz']);
    left = bandpassFilter(left',eeg.srate,freq(1), freq(2))';
    right = bandpassFilter(right',eeg.srate,freq(1), freq(2))';
        
    
    % Extraction
    disp(['Extracting with ' num2str(frame) 'ms']);
    left = ExtractSignalbyTrigger(left, eeg.event, eeg.srate, frame);
    right = ExtractSignalbyTrigger(right, eeg.event, eeg.srate, frame);
    
    left = reformsig(left',eeg.n_trials); % [ch x t] => [t x ch x trials]
    right = reformsig(right',eeg.n_trials);
    
    [accuracy info] = evalcspfldatest( left, right, 5,'msgon')
    result.accuracy=accuracy;
    result.info=info;
    result.sub = sub;
    
    save([sub '_csp_acc.mat'],'result');
end
