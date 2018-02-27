load('net-epoch-73.mat');

kernel_1 = lianghua_16(net.layers{1,1}.weights{1,1});
bias_1 = lianghua_16(net.layers{1,1}.weights{1,2});  %1*m

kernel_2 = lianghua_16(net.layers{1,5}.weights{1,1});
bias_2 = lianghua_16(net.layers{1,5}.weights{1,2});  %1*m

kernel_3 = lianghua_16(net.layers{1,9}.weights{1,1});
bias_3 = lianghua_16(net.layers{1,9}.weights{1,2});  %1*m

kernel_4 =lianghua_16( net.layers{1,12}.weights{1,1});
bias_4 = lianghua_16(net.layers{1,12}.weights{1,2});  %1*m

im = imread('hb14975-9.jpeg')*4;
im_ = imresize(im,[128 128]);
im_ = imcrop(im_,[15,9,95,95]);
im_ = single(im_)/255;
im_ = im_ - mean(im_(:));
im_ = bsxfun(@minus,im_,net.meta.normalization.averageImage);
im_ = lianghua_16(im_);