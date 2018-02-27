k = [];
for i = 1:36
    tmp = kernel_2(:,:,18,i);
    neg=find(tmp<0);
    tmp(neg)=tmp(neg)+65536; 
    tmp = vectorize(tmp);
    tmp = tmp';
    k = [k;tmp];
end

fid = fopen('kernel2_18.coe','wt'); %也可以生成TXT文件之后，将txt后缀改为coe 

fprintf( fid, 'memory_initialization_radix=10;\n');

fprintf( fid, 'memory_initialization_vector =\n' ); 

fprintf(fid,'%d,\n',k);

fclose(fid);
