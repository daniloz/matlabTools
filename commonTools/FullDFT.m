function [ampl,phase,f]=FullDFT(Signal,fs)
% Cacluation of the complete Spectra (-fNy...+fNy)

N=length(Signal);

if isreal(Signal)
    SpecCorr = 2;
else
    SpecCorr = 1;       % if an analytical signal is used (complex)
end


Sp = fft(Signal)./N.*SpecCorr;
Spec =[Sp((N/2+1):N);Sp(1:N/2)];% reorganize Spectrum: -fs/2..dC..fs/2

df=fs/N;
f=[-fs/2:df:(fs/2)-df];




ampl=abs(Spec);
phase=angle(Spec);

if nargout<1    % only plot data if no return value required
    %subplot(211)
    semilogx(f,20*log10(ampl));
    grid
   
    %subplot(212)
    %semilogx(f,phase);
    %grid
end
