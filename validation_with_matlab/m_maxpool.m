function [ C ] = m_maxpool( A,stride )
%M_MAXPOOL Summary of this function goes here
%   Detailed explanation goes here

m = size(A,1);

C = zeros(m/stride);

for i = 1:m/stride
    for j = 1:m/stride
        C(i,j) = max(reshape(A(stride*(i-1)+1:stride*i,stride*(j-1)+1:stride*j),[stride^2,1]));
    end
end

end

