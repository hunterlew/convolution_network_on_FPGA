function [ C ] = conv_ff( A,kernel,bias,pool_stride )
%COMPUTE_LAYER Summary of this function goes here
%   Detailed explanation goes here

in_size = size(A,1);
kernel_size = size(kernel,1);
out_size = (in_size - kernel_size + 1);
    
out_num = size(kernel,4);
in_num = size(A,3);
Ctmp = zeros(out_size,out_size,out_num);

if pool_stride
    out_size = out_size / pool_stride;
end
C = zeros(out_size,out_size,out_num);

for i = 1:out_num
    for j = 1:in_num
         Ctmp(:,:,i) = Ctmp(:,:,i) + m_conv2(A(:,:,j),kernel(:,:,j,i));
    end
    Ctmp(:,:,i) = Ctmp(:,:,i) + bias(i);
    if pool_stride
        C(:,:,i) = m_relu(m_maxpool(Ctmp(:,:,i),pool_stride));
    else
        C(:,:,i) = m_relu(Ctmp(:,:,i));
    end
end

end