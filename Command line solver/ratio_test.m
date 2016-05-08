function [ least_r index ] = ratio_test( a,b )
%This function is used for ratio test.
%  The index of the minimum ratio and the value of the ratio are returned.
    a=a(:);                           %Initializing the a vector as a column vector
    b=b(:);                           %Initializing the b Vector as a column vector
    l=1:length(a);
    l=l(b>0.00);                      %Filtering out the negative values in b
    r=a(l)./b(l);                     % Taking the ratio
    [least_r, pos]=min(r);            % computing the index and the value of the minimum ratio
    index = l(pos);
   

end

