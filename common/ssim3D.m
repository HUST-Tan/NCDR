function [ssim_mean, ssim_min] = ssim3D(X1,X2,K,window,L)

%Modified version of the SSIM index to work for image-stacks. 

% ========================== INPUT PARAMETERS (required) ==================
% Parameters    Values and description
% =========================================================================
% X1            processed image-stack.
% X2            ground-truth image-stack.
% K             constants in the SSIM index formula (see ssim_index.m).
%               default value: K = [0.01 0.03]
% window        local window for statistics (see ssim_index.m). default 
%               window is Gaussian given by window = fspecial('gaussian', 11, 1.5);
% L             dynamic range of the images. default: max(X2(:))-min(X2(:))
% ========================== OUTPUT PARAMETERS ============================
% ssim_mean    The mean ssim index over all the slices of the image stacks.
% ssim_min     The min ssim index over all the slices of the image stacks.
% =========================================================================

if nargin < 5
  window = fspecial('gaussian', 11, 1.5);
end

if nargin < 4
  K(1) = 0.01;
  K(2) = 0.03;
end

if nargin < 3
  L = max(X2(:))-min(X2(:));
end

if ~isequal(size(X1), size(X2)), error('non-matching X1-X2'); end

dim3=size(X1,3);

% if dim3==1
%   error('Input should be an image stack.');
% end

ssim_mean=0;
ssim_min=inf;
for i=1:dim3
  k=ssim_index(X1(:,:,i), X2(:,:,i), K, window, L);
  ssim_mean=ssim_mean+k;
  ssim_min=min(ssim_min,k);
end

ssim_mean=ssim_mean/dim3;

  
