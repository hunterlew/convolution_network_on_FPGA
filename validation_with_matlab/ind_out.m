
% a = 0:22*22-1;
% b = reshape(a,[22 22]);
% b = b';
% c = [];
% for i = 1:18
%     for j = 1:5
%         c = [c,b(j,i)];
%     end
% end

a = 0:18*18-1;
b = reshape(a,[18 18]);
b = b';
c = [];
for i = 1:6
    for j = 1:3
        c = [c,b(j,3*i-2)];
    end
end

fid = fopen('ind_layer3.coe','wt'); %也可以生成TXT文件之后，将txt后缀改为coe 

fprintf( fid, 'memory_initialization_radix=10;\n');

fprintf( fid, 'memory_initialization_vector =\n' ); 

fprintf(fid,'%d,\n',c);

fclose(fid);
