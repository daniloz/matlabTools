function [a, b] = lineEquationFromPoints(x1, y1, x2, y2)
% function [a, b] = lineEquationFromPoints(x1, y1, x2, y2)
%
% Computes the linear equation between points (x1,y1) and (x2,y2), i.e.
%   y = a*x + b

% Author: Danilo Zanatta (while working at NTi Audio AG)
% First version: 21.07.2011 at 11:30
% Last update: 21.07.2011 at 11:30

a = (y2 - y1) / (x2 - x1);
b = y1 - a*x1;
