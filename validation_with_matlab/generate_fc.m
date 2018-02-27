k=[];
for i=1:10
    for j=1:120
        k = [k kernel_4(1,1,j,i)];
    end
end

neg=find(k<0);
k(neg)=k(neg)+65536; 

fid = fopen('fc.coe','wt'); %???????и▓??TXT???????ио????txt?иоб┴?????coe 

fprintf( fid, 'memory_initialization_radix=10;\n');

fprintf( fid, 'memory_initialization_vector =\n' ); 

fprintf(fid,'%d,\n',k);

fclose(fid);