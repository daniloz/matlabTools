function b = iseven(n)
%ISEVEN True for even numbers
%   ISEVEN(N) returns 1 if N is even and 0 otherwise.
%       
%   ISEVEN works only on real integer inputs; for any other input, it
%   returns NaN
%
%   Example:
%       x = iseven(4);
%       y = iseven(5);
%       z = iseven(2.01);
%   In this example, iseven(4) returns true, iseven(5) returns false and
%   iseven(2.01) returns NaN.

% by Danilo Zanatta, last update on 24.11.2010 at 8h05

if isfinite(n) && isreal(n) && (round(n) == n), % only true for real integers
    b = logical( mod(n,2) == 0 );
else
    b = NaN;
end

end
