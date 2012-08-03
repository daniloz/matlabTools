function[signal,t]=sinus(fo,fs,N)

% Vektor einer Sinus Zeitfunktion : Frequenz=fo , bzw. Frequenzen : fo = Vektor 
%                                   Abtastfrequenz=fs
%                                   N samples
% Bemerkung : Amplitude=1
%             f�r eine ganze Anzahl M Perioden : fo=M/N*fs
%
% input  : Sinusfrequenz(en) , Abtastfrequenz , Anzahl samples
%    default:    1           ,       128      ,      128
%
% output : Spaltenvektoren : signal , Zeit
%     bzw:  Matrix , Vektor
%
% Aufruf : s=sinus(fo,fs,N);  oder  [s,t]=sinus(fo,fs,N);
%                             oder  s=sinus;
%
% ne , 28.5.96

% optional ohne Input Parameter
% auch f�r Sinus Schar : fo=Vektor , signal=Matrix

if nargin==0     % kein Parameter �bergeben
   fo=1;fs=128;N=128;
elseif nargin==1 % nur fo �bergeben
   fs=128;N=128;
elseif nargin==2 % nur fo und fs �bergeben
   N=fs;
end
       
t=(0:N-1)'/fs;

if length(fo)==1	% eine Sinusfrequenz
	signal=sin(2*pi*fo*t);
else
   signal=zeros(N,length(fo));
   for i=1:length(fo)      
   	 signal(:,i)=sin(2*pi*fo(i)*t);
   end
end
