function [ C ] = m_conv2( A,B )
%M_CONV Summary of this function goes here
%   Detailed explanation goes here

m = size(A,1);
n = size(B,1);

C = zeros(m-n+1);

for i = 1:m-n+1
    for j = 1:m-n+1
%         tmp = A(i:i+n-1,j:j+n-1) .* B ;
%         C(i,j) = sum(sum(tmp)) ;
        C(i,j) = sum(sum(A(i:i+n-1,j:j+n-1) .* B )) ;
    end
end

C = C/4096; % Ωÿ»°£¨Œ¨≥÷16Œª

end

