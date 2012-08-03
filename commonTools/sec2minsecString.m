function [str, m, s] = sec2minsecString(secs)
% SEC2MINSECSTRING convert a value in seconds to a string containing minutes and seconds
% [str, m, s] = sec2minsecString(secs)
%   Input:
%       secs = number of seconds
%   Output:
%       str = string in the format 00m 00s
%       m   = number of minutes
%       s   = number of seconds

m = floor(secs/60);
s = round(secs - m*60);
str = sprintf('%4dm %02ds', m, s);

end
