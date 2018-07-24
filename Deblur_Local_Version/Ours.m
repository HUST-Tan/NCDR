function [ x ] = Ours( y, H, lamda, alpha, method, iter )
    % iteration
    x = y;          %start point   
    step = 1;
    a = 0.3;        %0<a<0.5
    b = 0.7;        %0<b<1
    for ii = 1:iter
        %calculate the gradient of the object function to determine the search direction
        dir = -f_obs_gradient(x,y,H,alpha,method,lamda);
        dir_vector = dir(:);
        %line search,determine the step size 
    %     step = 1;
        while f_obs(x + step * dir,y,H,alpha,method,lamda)>f_obs(x,y,H,alpha,method,lamda)+a*step*(-dir_vector)'*dir_vector
            step = step*b;
        end
%         step;
        %update the x:=x + step_size*step_direction
        x = x + step * dir;
    end
    x(x<0)=0;
    x(x>255) = 255;
end

