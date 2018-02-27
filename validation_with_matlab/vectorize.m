function [ B ] = vectorize( A )
%VECTORIZE 将矩阵元素序列化，方便ROM存储，按行排列

[m,n] = size(A);
B = zeros(1,m*n);

for i=1:m
   for j=1:n
       B(1,(i-1)*n+j) = A(i,j);
   end
end

end

