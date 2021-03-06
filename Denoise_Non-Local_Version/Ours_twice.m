
clear
addpath('../common/');

image_name = {'barbara' 'boat' 'cameraman' 'couple' 'straw' 'hill' 'house' ...
    'Lena512' 'man' 'Monarch_full' 'peppers256' 'fingerprint'};

%%%------------------------------------------------------------------------
%%% Load Noise-free and noisy Images
%%%------------------------------------------------------------------------
num         = 7;
noise_level = 10;
path_x0     = ['../common/Denoising_test_images/' image_name{num} '.tif'];
x0          = double(imread(path_x0));
path_y      = ['../common/noisy_image_' num2str(noise_level) '/' image_name{num} '_noise.tif'];
y           = double(imread(path_y)); 

%%%------------------------------------------------------------------------
%%% Set Parameters
%%%------------------------------------------------------------------------
% Parameters for calculating w(x,y)
global W;
t = 2;                  % Search_size : 2*t+1;
f = 1;                  % Patch size  : 2*f+1;
h1 = 1;                 % Standard deviation of Gaussian kernel
h2 = 0.2;               % Threshold for distance
selfsim = 0;
% Parameters for updating a(x)
sigamma   = 5;          
M         = 1e3;        
% Other parameters
method    = 2;          % 1: STV1; 2: NCDR
alpha     = 1e3;        % Used for preprocessing
iter      = 1e3;        % The iteration number of GD 
lamda_pre = 22;         
lamda     = 4;  

%%%------------------------------------------------------------------------
%%% Pre-processing via NCDR with fixed a(x)
%%%------------------------------------------------------------------------
xd = Ours( y, lamda_pre, alpha, method, iter, 0);  

%%%------------------------------------------------------------------------
%%% Update a(x) using the pre-processed image
%%%------------------------------------------------------------------------
temp = xd;
x_gradient_abs = forward_diff(temp,1,1).^2 + forward_diff(temp,1,2).^2 + forward_diff(temp,1,3).^2;
x_gradient_abs = sqrt(x_gradient_abs+sqrt(eps));
alpha = M * exp(-(x_gradient_abs).^2/sigamma^2);

%%%------------------------------------------------------------------------
%%% Update a(x) using the pre-processed image
%%%------------------------------------------------------------------------
W = cal_W(xd/max(xd(:)),t,f,h1,h2,selfsim); 

%%%------------------------------------------------------------------------
%%% Image Denoising via NL_NCDR
%%%------------------------------------------------------------------------
% Denoising using Ours method
x = Ours( y, lamda, alpha, method, iter, 1); 
PSNR_NLNCDR = psnr(x,x0);
SSIM_NLNCDR = ssim3D(x,x0);
figure;
subplot(1,2,1); imshow(y,[]);
subplot(1,2,2); imshow(x,[]);