function r = randlogN(min,max,rows,cols)
% function r = randlogN(min,max,rows,cols)
%   - returns a rows x cols matrix with logarithm-uniform distributed values
%   bewteen min and max
%   - min and max must be (strictly) positive values
%
%   example:    r = randlogN(0.1, 500, 1, 100);

if nargin < 3,
    rows = 1;
    cols = 1;
end

minLog = log10(min);
maxLog = log10(max);
r = minLog + (maxLog-minLog)*rand(rows,cols);
r = 10.^r;
