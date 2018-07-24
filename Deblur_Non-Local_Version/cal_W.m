function [ W ] = cal_W( input,t,f,h1,h2,selfsim )
%CAL_W Summary of this function goes here
%   Detailed explanation goes here

 [m, n]=size(input);
 s = m*n;
 
 psize = 2*f+1;
 nsize = 2*t+1;

 % Compute patches
 padInput = padarray(input,[f f],'symmetric'); 
 filter = fspecial('gaussian',psize,h1);      % this is equivalent to process the noisy patch with Gaussian filter  
 patches = repmat(sqrt(filter(:))',[s 1]) .* im2col(padInput, [psize psize], 'sliding')';
 
 % Compute list of edges (pixel pairs within the same search window) %'edge'->'index' 
 indexes = reshape(1:s, m, n);
 padIndexes = padarray(indexes, [t t]);
 neighbors = im2col(padIndexes, [nsize, nsize], 'sliding');
 TT = repmat(1:s, [nsize^2 1]);
 edges = [TT(:) neighbors(:)];
 RR = find(TT(:) >= neighbors(:));
 edges(RR, :) = [];
 
 % Compute weight matrix (using weighted Euclidean distance)
iter = size(edges,1);
step = floor(iter/1e2);
V = zeros(iter,1);
for ii = 1:step:iter
    if (ii+step-1) < iter
    diff = patches(edges(ii:ii+step-1,1), :) - patches(edges(ii:ii+step-1,2), :);    
    V(ii:ii+step-1) = exp(-sum(diff.*diff,2)/h2^2);
    end
end
clear diff;
diff = patches(edges(ii:iter,1), :) - patches(edges(ii:iter,2), :);
V(ii:iter) = exp(-sum(diff.*diff,2)/h2^2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  clear diff;
 W = sparse(edges(:,1), edges(:,2), V, s, s);
 
%  Make matrix symetric and set diagonal elements
 if selfsim > 0
    W = W + W' + selfsim*speye(s);
 else
     maxv = max(W,[],2);
     W = W + W' + spdiags(maxv, 0, s, s);
 end     
 
%%%%%%%%%%%%%%%%%%% 
a = W;
asize = size(a);
num = 25;
for ii = (1:num)
    [~, index((ii-1)*asize(1)+1:ii*asize(1))] = max(a,[],2);
    a = a';
    index_a = ([1:asize(1)] - 1) * asize(2) + index((ii-1)*asize(1)+1:ii*asize(1));
    a(index_a) = 0;
    a = a';
end
  
c = sparse(repmat([1:asize(1)],[1,num]), index, ones(1,num*asize(1)), asize(1), asize(2));
W = W.*c;

end

