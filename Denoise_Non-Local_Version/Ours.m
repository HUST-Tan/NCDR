function [ x ] = Ours( y, lamda, alpha, method, iter, NL_flag)
    % iteration
    x = y;          %start point   
    step = 1;
    a = 0.3;        %0<a<0.5
    b = 0.7;        %0<b<1
    for ii = 1:iter
        %calculate the gradient of the object function to determine the search direction
        dir = -f_obs_gradient(x,y,lamda,method,alpha, NL_flag);
        dir_vector = dir(:);
        %line search,determine the step size 
    %     step = 1;
        while f_obs(x + step * dir,y,lamda,method,alpha, NL_flag)>f_obs(x,y,lamda,method,alpha, NL_flag)+a*step*(-dir_vector)'*dir_vector
            step = step*b;
        end
        %update the x:=x + step_size*step_direction
        x = x + step * dir;
    end
    x(x<0)=0;
    x(x>255) = 255;
end

