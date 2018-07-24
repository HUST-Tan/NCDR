
clear
addpath('../common/');

image_name = {'barbara' 'boat' 'cameraman' 'couple' 'straw' 'hill' 'house' ...
    'Lena512' 'man' 'Monarch_full' 'peppers256' 'fingerprint' 'block'};

%%%------------------------------------------------------------------------
%%% Load Noise-free and noisy Images
%%%------------------------------------------------------------------------
num         = 7;
noise_level = 5;
% Read orginal image
path_x0 = ['../common/Denoising_test_images/' image_name{num} '.tif'];
x0      = double(imread(path_x0));
% Read deblurred image
path_y  = ['../common/Gaussian_blur_1_' num2str(noise_level) '/' image_name{num} '_degraded.tif'];
y       = double(imread(path_y)); 
% Set the blur kernel
h       = double(fspecial('Gaussian',[9 9],1));
H       = psf2otf(h,size(y));   % Conver psf to OTF

%%%------------------------------------------------------------------------
%%% Set Parameters
%%%------------------------------------------------------------------------
iter      = 1e3;        % The iteration number of GD 
lamda_pre = 2.8;         
lamda     = lamda_pre;  % The regularization parameter
method    = 2;          % 1: STV1; 2: NCDR
alpha     = 1e3;        % Used for preprocessing
sigamma   = 5;          % Used for updating a(x)
M         = 1e3;        % Used for updating a(x)

%%%------------------------------------------------------------------------
%%% Pre-processing via NCDR with fixed a(x)
%%%------------------------------------------------------------------------
xd = Ours( y, H, lamda_pre, alpha, method, iter );  

%%%------------------------------------------------------------------------
%%% Update a(x) using the pre-processed image
%%%------------------------------------------------------------------------
temp = xd;
x_gradient_abs = central_diff(temp,1,1).^2 + central_diff(temp,1,2).^2 + central_diff(temp,1,3).^2;
x_gradient_abs = sqrt(x_gradient_abs+sqrt(eps));
alpha = M * exp(-(x_gradient_abs).^2/sigamma^2);

%%%------------------------------------------------------------------------
%%% Image Deblurring via NCDR
%%%------------------------------------------------------------------------
x = Ours( y, H, lamda, alpha, method, iter );  
PSNR_NCDR = psnr(x,x0);
SSIM_NCDR = ssim3D(x,x0);
figure;
subplot(1,2,1); imshow(y,[]);
subplot(1,2,2); imshow(x,[]);