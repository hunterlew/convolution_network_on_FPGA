function [ A ] = m_relu( A )
%M_RELU Summary of this function goes here
%   Detailed explanation goes here

A = A.* (A > 0);

end
