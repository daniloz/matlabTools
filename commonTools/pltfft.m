function [ampl,phase,f]=pltfft(signal,fs, cl, legendLabel)
% berechnet eine FFT aus den Werten in Signal
N=length(signal);

% Make N pair
if rem(N,2) == 1, % N is odd
    signal=signal(1:end-1);
    N=length(signal);
end

spec=fft(signal);

ampl = abs(spec(1:N/2)/N*2);
% Replace Zeros with EPS
indZero = (ampl == 0);
ampl(indZero) = eps;
% Same as the following code, but more efficient
%for i = 1:N/2
%    if (ampl (i) == 0)
%        ampl (i) = eps ();
%    end
%end

phase=angle(spec(1:N/2)/N*2);

f=0:fs/N:(fs/2-fs/N);

if (nargin <= 2)
    cl = '-b';
end
if nargin <= 3,
    legendLabel = 'pltfft';
end

if nargout<1    % only plot data if no return value required
    %subplot(211)
    semilogx(f,20*log10(ampl), cl, 'DisplayName', legendLabel);
    grid on
	xlabel('Frequency [Hz]')
	ylabel('Amplitude [dB]')
   
	clear ampl
    %subplot(212)
    %semilogx(f,phase);
    %grid
end
