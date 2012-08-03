function[signal,t]=noise(fs,N);

% Rausch Zeitfunktion : Spitzenwert=1 , N samples
% Für Realisierungen mit gleichem Effektivwert=1
% verwenden Sie besser : randn(N,1)
%
% optionale inputs	:	Abtastfrequenz
%								Anzahl samples N (default:1024)
%						
% output 				: 	Spaltenvektoren : signal , Zeit t
%
% Aufruf : s=noise; oder s=noise(N); oder [s,t]=noise(fs,N); 
%
% ne , 6.3.96

% default Wert für N

if nargin==0 , N=1024;
elseif nargin==1 , N=fs; end
        
signal=randn(N,1);
signal=signal./max(abs(signal));% Normierung auf Spitzenwert 1

if nargout==2 % then berechne Vektor t
   if nargin==2 , t=((0:(N-1))/fs)';
   else , disp('need fs to calculate t Vector !') , end
end  
