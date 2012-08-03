FOUR_CH = 1;

if ~exist('fx','var'),
    fx = FxUsb(600,1.5e6);
    fx.CloseAll;
else
    fx.CloseAll;
end
fx.Connect
fx.QueryError
clc

AVG = 3000;
DELAY = 1; %sec

temp_time = NaN*ones(1,AVG);
if FOUR_CH,
    temp_time2 = NaN*ones(1,AVG);
end
thd_time_X = (0:AVG-1)*DELAY;

togglefig('Temperature x Time')
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


tic
for a = 1:AVG,
    thd_time_X(a) = toc;
    
    tmp = fx.Query('system:hardware:ADC1:Temperature?');
    temp_time(a) = str2double(tmp(1:10));
    set(htt, 'XData',thd_time_X, 'YData',temp_time);
    
    if FOUR_CH,
        tmp = fx.Query('system:hardware:ADC2:Temperature?');
        temp_time2(a) = str2double(tmp(1:10));
        set(htt2, 'XData',thd_time_X, 'YData',temp_time2);
    end
    
    pause(DELAY);
    drawnow
end
toc

fx.Disconnect
