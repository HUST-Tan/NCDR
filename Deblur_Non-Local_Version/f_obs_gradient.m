function output = f_obs_gradient( x, y, H, lamda, method, alpha, NL_flag )
    a = 1/2;
    b = (1-a)/2;
    
    % the derivative of the fidelity term
    output = ifftn(H.*fftn(x)) - y;                         
    output = ifftn(conj(H).*fftn(output));                  
    
    % the derivative of the regularization term
    output = output + b * f_obs_gradient_diff_select( x, y, lamda, alpha, method, 1, NL_flag );
    output = output + b * f_obs_gradient_diff_select( x, y, lamda, alpha, method, 2, NL_flag );
    output = output + a * f_obs_gradient_diff_select( x, y, lamda, alpha, method, 3, NL_flag );
end