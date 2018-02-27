
%IMRECOG Summary of this function goes here
%   Detailed explanation goes here
clear;clc;

tic
%% 初始化

pool1_stride = 4;
pool2_stride = 3;

load('net-epoch-73.mat');

kernel_1 = lianghua_16(net.layers{1,1}.weights{1,1});
bias_1 = lianghua_16(net.layers{1,1}.weights{1,2});  %1*m

kernel_2 = lianghua_16(net.layers{1,5}.weights{1,1});
bias_2 = lianghua_16(net.layers{1,5}.weights{1,2});  %1*m

kernel_3 = lianghua_16(net.layers{1,9}.weights{1,1});
bias_3 = lianghua_16(net.layers{1,9}.weights{1,2});  %1*m

kernel_4 =lianghua_16( net.layers{1,12}.weights{1,1});
bias_4 = lianghua_16(net.layers{1,12}.weights{1,2});  %1*m

im = imread('hb03417-2.jpeg')*4;
im_ = imresize(im,[128 128]);
im_ = imcrop(im_,[15,9,95,95]);
im_ = single(im_)/255;
im_ = im_ - mean(im_(:));
im_ = bsxfun(@minus,im_,net.meta.normalization.averageImage);
im_ = lianghua_16(im_);
% im_ = vectorize(im_);
% neg=find(im_<0);
% im_(neg)=im_(neg)+65536

%% 前向计算 
tic;
layer_2 = conv_ff(im_,kernel_1,bias_1,pool1_stride);

layer_3 = conv_ff(layer_2,kernel_2,bias_2,pool2_stride);

layer_4 = conv_ff(layer_3,kernel_3,bias_3,0);

layer_5 = conv_ff(layer_4,kernel_4,bias_4,0)
layer_5 = layer_5/4096;
% 
layer_6 = m_softmax(layer_5);
[score,class] = max(layer_6);
toc;

% score
class

