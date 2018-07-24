function [snr_db, MSE] = psnr(X1, X2, peak)

% ========================== INPUT PARAMETERS (required) ==================
% Parameters    Values and description
% =========================================================================
% X1            processed image-stack.
% X2            ground-truth image-stack.
% peak          peak value used in the computation of the PSNR. (Default:
%               maximum value of X2).
% ========================== OUTPUT PARAMETERS ============================
% snr_db        Peak signal-to-noise-ratio.
% MSE           Mean squared error between argument 1 and argument 2.
% =========================================================================

%Author: stamatis.lefkimmiatis@epfl.ch (Biomedical Imaging Group)

 
% PSNR(db) = 10*log10( peak^2 / MSE )


if nargin<3, peak=max(X2(:)); end
if ~isequal(size(X1), size(X2)), error('non-matching X1-X2'); end
N = length(X1(:));

if N==0,
  snr_db=nan;
  MSE=0;
  return;
end

MSE = sum((X1(:)-X2(:)).^2)/N;

if MSE==0,
  snr_db=inf;
else
  snr_db = 10*log10(peak^2/MSE);
end