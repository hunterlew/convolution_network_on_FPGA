function [ B ] = vectorize2( A )
%VECTORIZE 将矩阵元素序列化，方便ROM存储，按行排列

m = size(A,4);
B = [];

for i = 1:m
    B = [B,vectorize(A(:,:,:,i))];
end

end

