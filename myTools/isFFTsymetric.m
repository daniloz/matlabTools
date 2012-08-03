function b = isFFTsymetric(X)
%isFFTsymetric True for conjugate symetrical FFT, i.e. from a real time signal
%   isFFTsymetric(X) returns 1 if X is a conjugate symetrical FFT and 0 otherwise
%
%
%   Example:
%       x = sin(2*pi*100*(0:1023)/1024); % 1024 points FFT, 100Hz @ 1024Hz sampling rate
%       X = fft(x);
%       b = isFFTsymetric(X);
%   In this example, isFFTsymetric(X) returns true.

% by Danilo Zanatta, last update on 29.11.2010 at 9h10

nX = length(X);
if iseven(nX)
    nXhalf = nX/2;
    % FFT = [b_0=DC b_1...b_(nXhalf-1) b_nXhalf=Nyquist | b_(nX-nXhalf+1)=b_(-nXhalf+1)...b_(nX-1)=b_(-1)]
    % DC = X(1);
    baseFFT = X( (1:nXhalf-1) +1 );
    % Nyquist = X(nXhalf+1);
    mirrorFFT = X( nX - (1:(nXhalf-1)) +1 );
    b = all(baseFFT == conj(mirrorFFT));
else
    warning('isFFTsymetric:notImplemented', 'Odd number of samples not yet implemented.')
    b = NaN;
end

end
