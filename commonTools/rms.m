function [u_rms,u_max,crest] = rms(s)
% Funktion Effektivwertberechnung, optional: Spitzenwert, Crestfaktor 
%
% input:   Signal : s (Spaltenvektor)
% output:  Effektivwert , optional : Spitzenwert , Crestfaktor
%                     
% Aufruf: u=rms(signal);   bzw:   [u_rms,u_max,crest]=rms(signal);
%
% ne 7.9.93

s_square = s.*s;
u_rms = sqrt(sum(s_square)/length(s));
if nargout>1,
    u_max = max(abs(s));
    crest = u_max/u_rms;
end
% schneller als abs(max(x)) -> norm(x,inf) !!!
