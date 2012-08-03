function out = even(in)
% Function out = even(in)
%   Returns the greatest even integer after in

out = fix(in); % convert to integer
if ~iseven(in),
    out = in + 1;
end

end
