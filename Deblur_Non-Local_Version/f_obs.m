function output = f_obs( x, y, H, lamda, method, alpha, NL_flag)
    a = 1/2;
    b = (1-a)/2;
    
    % calculate the data fidelity term
    output = 0.5*(ifftn(H.*fftn(x))-y).^2;
    output = sum(output(:));
    
    % calculate the regularization term
    output = output + b * f_obs_diff_select( x, y, lamda, alpha, method, 1, NL_flag );
    output = output + b * f_obs_diff_select( x, y, lamda, alpha, method, 2, NL_flag );
    output = output + a * f_obs_diff_select( x, y, lamda, alpha, method, 3, NL_flag );
end
