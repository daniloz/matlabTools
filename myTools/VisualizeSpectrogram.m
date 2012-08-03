function VisualizeSpectrogram(name,x,window,overlap,nfft,fs,range)
if nargin < 7,
    range = 150;
end
togglefig(name)
[~,f,t,p] = spectrogram(double(x),window,overlap,nfft,fs);
hp = pcolor(t,f,20*log10(abs(p)));
set(hp,'FaceColor','interp', 'EdgeColor','none');
%set(gca,'YScale','log', 'Box','on');
set(gca,'YScale','lin', 'Box','on');
axis xy; axis tight; view(0,90);
xlabel('Time [s]');
ylabel('Frequency (Hz)');
Clims = max(max(20*log10(abs(p)))) + [-range 0];
set(gca,'CLim',Clims, 'CLimMode','manual');
colorbar('peer',gca);
colormap(gca,'jet');
end
