function [NewSignal, Ave_Signal] = ExtractSignalbyTrigger(signal, trigger, srate, frame, opt)
%
% function [NewSignal, Ave_Signal] = ExtractSignalbyTrigger(signal, trigger, srate, frame, opt)
% 
% *** INPUT ***
%   signal [channel by time]
%   trigger [vector]    : has Event position with number > 0
%   srate  [scalar]     : sampling rate
%   frame [start end]   : has elements indicating start and end time(in msec)
%          ex) [-1000er the tri 1000] means 1sec before and 1sec aftgger
%   opt [string]    : if opt is 'average' then output signal is averaged
%   over all trials
%
% *** OUTPUT ***
%   NewSignal [channel by time] : concatenated form with every trials
%                                   extracted with the interval 'frame'
%   Ave_Signal [channels by time(n_samples)] : Averaged form over trials of NewSignal
%
% *** USEAGE ***
% function [NewSignal] = ExtractSignalbyTrigger(signal, trigger, srate, frame)
% function [NewSignal, Ave_Signal] = ExtractSignalbyTrigger(signal, trigger, srate, frame, opt)
% 
%
% *** CAUTION ***
% if signal is shorter than input 'frame' then returns empty []
%
%
% Bio-Computing Lab. Minkyu Ahn, 2009.8.25
% http://biocomput.gist.ac.kr       frerap@gist.ac.kr
%
%
% *** MODIFICATION ***
% 2009/09/25, Minkyu : sp = idx(itr)+start_sam  ->  sp = idx(itr)+start_sam+1;
%
% 2010.08.10 : Minkyu ahn
%   - opt == 'average' line modified since AverageOverTrials() function
%   needs only 2 input
%
%

MSG = 'ExtractSignalbyTrigger() : ';

NewSignal = [];
Ave_Signal = [];
%%

start_sam = floor(srate*frame(1)/1000);
end_sam = floor(srate*frame(2)/1000);

n_samples = end_sam - start_sam;

idx = find(trigger>0);
n_trials = length(idx);

% signal should be long enough
if(size(signal,2) < n_samples*n_trials)
	disp([MSG 'signal should be long enough.']);
    return;
end

index = zeros(1,n_samples*n_trials);
for itr=1:n_trials
    sp = idx(itr)+start_sam+1;
    ep = idx(itr)+end_sam;
%     if(sp > length(signal) | ep> length(signal))
%         disp([MSG 'strange'])
%     end

    index((itr-1)*n_samples + 1 : itr*n_samples) = [sp:ep];
end

   NewSignal = signal(:,index); 


if(exist('opt','var') & strcmp(opt,'average'))
    Ave_Signal = AverageOverTrials(NewSignal, n_trials);
end

