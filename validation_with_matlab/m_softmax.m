function [ A ] = m_softmax( A )
%M_SOFTMAX Summary of this function goes here
%   Detailed explanation goes here

A = exp(A - max(A));
A = A/sum(A);

end

