function output = f_obs_gradient( x,y,lamda,method,alpha )
    a = 1/2;
    b = (1-a)/2;
    output = b * f_obs_gradient_diff_select( x,y,lamda,alpha,method,1 );
    output = output + b * f_obs_gradient_diff_select( x,y,lamda,alpha,method,2 );
    output = output + a * f_obs_gradient_diff_select( x,y,lamda,alpha,method,3 );
end