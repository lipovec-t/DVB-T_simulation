function [y]=convolve(h,x)
% Convolve two sequences h and x of arbitrary lengths: y=h*x
    H=convMatrix(h,length(x)); 
    y=H*x.'; % equivalent to conv(h,x) inbuilt function
end

function H = convMatrix(h,p)
% Construct the convolution matrix of size (N+p-1)x p from the input
% vector h of size N.  
    h=h(:).';
    col=[h zeros(1,p-1)]; row=[h(1) zeros(1,p-1)];
    H=toeplitz(col,row);
end