function [ m j ] = blands_rule( b )
%Bland's pivoting rules are used to prevent cycling.
%Balnds rule is a determinstic rule to prevent cycling by choosing the
%variable with the lowest index.
% Reference:- New Finite Pivoting Rules for Simplex Method, Robert G Bland,
%             Mathematics of Operations Research, Vol. 2, No. 2, May 1997.

ind = find(b < 0);
if (~isempty(ind))
j = ind(1);                    %Choosing the lowest index
m = b(j);
else
m = [];
j = [];
end


end

