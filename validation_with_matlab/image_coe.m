%% ================Xilinx FPGA RAM COE文件生成程序 ===============


im_ = vectorize(im_);

neg=find(im_<0);
im_(neg)=im_(neg)+65536; 

fid = fopen('image.coe','wt'); %也可以生成TXT文件之后，将txt后缀改为coe 

fprintf( fid, 'memory_initialization_radix=10;\n');

fprintf( fid, 'memory_initialization_vector =\n' ); 

fprintf(fid,'%d,\n',im_);

fclose(fid);
