function Bol = TestInteger( ObjectVector )
% ObjectVector can be a number , a vector or a matrix
% If Bol = 1, all elements in ObjectVector are integers
% If Bol = 0, at least one element in ObjectVector is not integer
% This function is written by Lowell Guangdi 2009/6/8
% Improved by the idea of Jan Simon.

%Bol = isequal( ObjectVector, round( ObjectVector )) ;
Bol = ObjectVector == round( ObjectVector );
end
