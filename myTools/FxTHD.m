Nfft = 8192;
CH = 2;
FOUR_CH = 0;
THDN = 0;


% 0 for THD only and 1 for THD+N

Nfft_2 = Nfft/2;
fs = 192e3;
df = fs / Nfft;
Nc = length(CH);

%FREQ = 43*df; % 1007.8125
%FREQ = 40*df; % 937.5;
FREQ = 999.9855;
%FREQ = 4.5e3;
%FREQ = 562.5;

BinInt = floor(FREQ./df);
NSamplesFullPeriods = floor(fs./FREQ.*BinInt + 0.5);
Nfft_2 = NSamplesFullPeriods/2;

% New df
df = fs / NSamplesFullPeriods;

bin_1k = round(FREQ/df) +1;
bin_20 = max(5,round(20/df) +1);
bin_22k = round(20e3/df) +1;

ind_harmonics = (2*bin_1k-1) : (bin_1k-1) : bin_22k;

if ~exist('fx','var'),
    fx = FxUsb(600,1.5e6);
else
    fx.CloseAll;
end
fx.Connect
fx.Send('sense:fft:size SIZE%d',Nfft)
fx.Send('sense:resulttransfer entire')
fx.Send('sense:fft:Npoints %d',Nfft)

for ch = 1:Nc,
    fx.Send('sense%d:fft:active on', CH(ch))
    fx.Send('sense%d:fft:unit V', CH(ch))
    fx.Send('sense%d:fft:domain TIME', CH(ch))
    
    fx.Send('input%d:range manual', CH(ch))
    fx.Send('input%d:range:set 19 dbvp', CH(ch))
end
%fx.Send('output1:function:sine:frequency 1000 Hz')
%fx.Send('output1:level 0dbvp')

fx.QueryError
clc

avg = zeros(Nc,Nfft_2);
amax = zeros(Nc,Nfft_2);
amin = 1e100*ones(Nc,Nfft_2);
%AVG = 16;
AVG = 2000;

fft_time = zeros(AVG,Nfft_2);
thd_time = NaN*ones(Nc,AVG);
thdn_time = NaN*ones(Nc,AVG);
temp_time = NaN*ones(1,AVG);
if FOUR_CH,
    temp_time2 = NaN*ones(1,AVG);
end
thd_time_X = (0:AVG-1)*3;


%%
[ff,tmp,freq] = pltfft(1:NSamplesFullPeriods,192e3);
fig = figure(2);
clf
box on
hold on
hfft = plot(freq,ones(Nc,Nfft_2)*NaN);
hks = plot((ind_harmonics-1)*df, ones(size(ind_harmonics))*NaN,'ro');
hmin = plot(freq,ones(Nc,Nfft_2)*NaN);
hmax = plot(freq,ones(Nc,Nfft_2)*NaN);
hold off
xlim([20 22e3])
ylim([-150 20])
ylabel('FFT magnitue [dB]')
xlabel('frequency [Hz]')
grid on
legend('1')

time = (0:Nfft-1)'/192e3;
tmp = NaN*ones(1,Nfft);

PLOT_TIME = 0;
if PLOT_TIME,
    figure(1)
    subplot(311)
    hm1 = plot(time, tmp, 'b', 'linewidth', 2);
    hold on
    hf1 = plot(time, tmp, 'r--', 'linewidth', 2);
    hold off
    grid on
    ylim([-10 10])
    subplot(312)
    hm2 = plot(time, tmp, 'k', 'linewidth', 2);
    hold on
    hf2 = plot(time, tmp, 'r--', 'linewidth', 2);
    hold off
    grid on
    ylim([-5 5]*1e-4)
    subplot(313)
    hm3 = plot(time, tmp, 'k', 'linewidth', 2);
    hold on
    hf3 = plot(time, tmp, 'r--', 'linewidth', 2);
    hold off
    grid on
    ylim([-5 5]*1e-4)
end

%%
figure(3)
ht = plot(thd_time_X,thd_time, '.-', 'linewidth',2);
hold on
htn = plot(thd_time_X,thd_time, 'r.-', 'linewidth',2);
hold off
ylabel('THD(+N) [dB]')
xlabel('time [s]')
grid on

figure(4)
htt = plot(thd_time_X,temp_time(1,:),'r.-', 'linewidth',2);
if FOUR_CH, 
    hold on
    htt2 = plot(thd_time_X,temp_time2(1,:),'m.-', 'linewidth',2);
    hold off
    legend('ADC 1','ADC 2')
end
grid on
ylabel('Temperature [°C]')
xlabel('time [s]')

figure(5)
ht_t = plot(temp_time,thd_time(1,:),'.-', 'linewidth',2);
hold on
htn_t = plot(temp_time,thd_time,'r.-', 'linewidth',2);
hold off
grid on
xlabel('Temperature [°C]')
ylabel('THD [dB]')
axis([30 90 -120 -90])



%%
%hw = hanning(Nfft)';
hw = blackmanharris(NSamplesFullPeriods)'; winCor = adb(5.8696);
%hw = ones(Nfft,1)';
tic
for a = 1:AVG,
    fx.InitiateSingle
    thd_time_X(a) = toc;
    
    for ch = 1:Nc,
        m=fx.ParseFFTQuery(CH(ch));
        
        % DC wipe out
        m.Magnitude = m.Magnitude - mean(m.Magnitude);
        
        % AP correction
        %m.Magnitude = 0.3141 * 5.9635 * m.Magnitude;
        
        if PLOT_TIME,
            
            Nh = 4;
            
            mag{1} = m.Magnitude';
            [cfunt,gof,output] = fit(time, mag{1}, 'sin1');
            cfun{1} = cfunt;
            ffit{1} = cfun{1}.a1*sin(cfun{1}.b1*time + cfun{1}.c1);
            
            for n = 1:Nh,
                mag{n+1} = mag{n}-ffit{n};
                mag{n+1} =mag{n+1} - mean(mag{n+1});
                [cfunt,gof,output] = fit(time, mag{n+1}, 'sin1');
                cfun{n+1} = cfunt;
                ffit{n+1} = cfun{n+1}.a1*sin(cfun{n+1}.b1*time + cfun{n+1}.c1);
            end
            
            
            set(hm1, 'YData', mag{1});
            set(hf1, 'YData', ffit{1});
            set(hm2, 'YData', mag{2});
            set(hf2, 'YData', ffit{2});
            set(hm3, 'YData', mag{3});
            set(hf3, 'YData', ffit{3});
        end
        
        [ff,tmp,freq] = pltfft(winCor * m.Magnitude(1:NSamplesFullPeriods) .* hw,192e3);
        
        avg(ch,:) = avg(ch,:) + ff;
        amax(ch,:) = max([amax(ch,:); ff]);
        amin(ch,:) = min([amin(ch,:); ff]);
        
        if ch == 1,
            fft_time(a,:) = ff;
        end
        
        % Update plot
        %set(hfft(ch),'YData',db(avg(ch,:)/a), ...
        %    'DisplayName', sprintf('Max = %5.2f dB',db(max(abs(avg/a)))))
        
        %set(hfft(ch),'YData',db(avg(ch,:)/a), ... %ff), ...
        %    'DisplayName', sprintf('Max = %5.2f dB\nTHD = %5.2f',...
        %    db(max(abs(ff))), THD_AVG(ch)))
        
        %set(hmin(ch),'YData',db(amin(ch,:)))
        %set(hmax(ch),'YData',db(amax(ch,:)))
        set(fig,'Name',sprintf('avg = %3d / %3d',a,AVG))
        
        %if THDN,
            THDN_AVG(ch) = db( sum(abs(avg(ch,[bin_20:(bin_1k-30) (bin_1k+30):bin_22k])).^2) / ...
                sum( abs(avg(ch,bin_20:bin_22k)).^2 ) , 'power');
            
            THDN(ch) = db( sum(abs(ff([bin_20:(bin_1k-30) (bin_1k+30):bin_22k])).^2) / ...
                sum( abs(ff(bin_20:bin_22k)).^2 ) , 'power');
            thdn_time(ch,a) = THDN(ch);
            %fprintf(1,'[%3d/%3d] THD+N[%1d] = %9.4f / avg = %9.4f\n',a,AVG,CH(ch),THDN(ch),THDN_AVG(ch))
        %else
            %ind_harmonics = (2*bin_1k-1) : (bin_1k-1) : bin_22k;
            THD_AVG(ch) = db( sum(avg(ch,ind_harmonics).^2) / avg(ch,bin_1k)^2 , 'power' );
            
            THD(ch) = db( sum(ff(ind_harmonics).^2) / ff(bin_1k)^2 , 'power' );
            thd_time(ch,a) = THD(ch);
            %set(hks,'YData',db(ff(ind_harmonics)))
            set(hks,'YData',db(avg(ch,ind_harmonics)/a))
            fprintf(1,'[%3d/%3d] THD[%1d] = %9.4f / avg = %9.4f\n',a,AVG,CH(ch),THD(ch),THD_AVG(ch))
        %end

        if a > 1,
            set(hfft(ch),'YData',db(ff), ... %db(avg(ch,:)/a), ...
                'DisplayName', sprintf('Max = %5.2f dB\nTHD = %5.2fdB\nTemp = %4.2f°C',...
                db(max(abs(ff))), THD_AVG(ch), temp_time(a-1)))
        end

        
        %MAVGsize = 10;
        %mavg = conv(thd_time(ch,:),ones(1,MAVGsize)/MAVGsize);
        %set(htn(ch), 'XData',thd_time_X, 'YData',thdn_time(ch,:));
        set(ht(ch), 'XData',thd_time_X, 'YData',thd_time(ch,:));
        %set(ht(ch), 'XData',thd_time_X, 'YData',mavg(MAVGsize:end));
    end
    
    tmp = fx.Query('system:hardware:ADC1:Temperature?');
    %tmp(1:10)
    temp_time(a) = str2double(tmp(1:10));
    set(htt, 'XData',thd_time_X, 'YData',temp_time);
    
    if FOUR_CH,
        tmp = fx.Query('system:hardware:ADC2:Temperature?');
        %tmp(1:10)
        temp_time2(a) = str2double(tmp(1:10));
        set(htt2, 'XData',thd_time_X, 'YData',temp_time2);
    end
    
    set(ht_t, 'XData',temp_time, 'YData',thd_time(1,:));
    %set(htn_t, 'XData',temp_time, 'YData',thdn_time(ch,:));
    drawnow
end
toc

fx.Disconnect


togglefig('Lots of Harmonics')
plot(thd_time_X,db(fft_time(:,(2:13)*(bin_1k-1) +1))-db(fft_time(1,bin_1k)),'linewidth',2)
ylabel('Magnitude wrt to k1 [dB]')
xlabel('time [s]')
grid on
legend('k2','k3','k4','k5','k6','k7','k8','k9','k10','k11','k12','k13')

ks = [3 4 5 6 7 11];
q = db(sqrt(sum( (fft_time(:,ks*(bin_1k-1) +1) / fft_time(1,bin_1k)).^2,2)));
togglefig('Relevant Harmonics')
plot(thd_time_X, db(fft_time(:,ks*(bin_1k-1) +1))-db(fft_time(1,bin_1k)),'linewidth',2)
hold on
plot(thd_time_X, q, 'k--', 'linewidth', 3)
hold off
ylabel('Magnitude wrt to k1 [dB]')
xlabel('time [s]')
grid on
legend(cellfun(@(x) sprintf('k%d',x),num2cell(ks), 'UniformOutput', false),...
    'THD based on these harmonics')
