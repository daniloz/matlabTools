if playrec('isInitialised')
    fprintf('   Resetting playrec as previously initialised\n');
    playrec('reset');
end

Fs = 192e3;

playDevId = 19;
playChan = 3;

recDeviceID = 19;
recChan = 9;


try
    playrec('init', Fs, playDevId,recDeviceID, 16,16, 0, 4096,4096);
    fprintf('   Initialising device at %dHz succeeded\n', Fs);
catch ME
    fprintf('   Initialising device at %dHz failed with error: %s\n', Fs, ME.message);
end

f0 = 1000;
f1 = 1000.00001;
T = 1;
% T = max(2,T); % should be greater than 2
fadeIn = 200e-3; % fade-in in s
t = (0:(T*Fs-1))/Fs;
sweep = chirp(t,f0,T,f1,'logarithmic');
nFade = round(fadeIn*Fs); %20ms
fadeOut = (1+cos(pi*(0:nFade-1)/nFade))/2;
sweep(1:nFade) =  sweep(1:nFade) .* fliplr(fadeOut);
sweep(end-nFade+1:end) =  sweep(end-nFade+1:end) .* fadeOut;
sweep = sweep(:);

%Clear all previous pages before starting recording
playrec('delPage');
pageSize = length(sweep) + 4*4096;    %size of each page processed

fprintf('      Adding output on channel %d\n', playChan);
pageNum = playrec('playrec', sweep, playChan, pageSize, recChan)
playrec('resetSkippedSampleCount')

%This could use the block command instead
while(playrec('isFinished') == 0)
end

lastRecording = playrec('getRec', pageNum);
playrec('getSkippedSampleCount')

figure(12)
plot(lastRecording)
