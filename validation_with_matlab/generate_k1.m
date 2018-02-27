
k = kernel_1(:,:,1,1);
neg=find(k<0);
k(neg)=k(neg)+65536; 
k = vectorize(k);
k = k';

