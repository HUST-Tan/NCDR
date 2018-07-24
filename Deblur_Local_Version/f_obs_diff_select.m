function output = f_obs_diff_select( x,y,lamda,alpha,method,mode )
    %calculate the ST
    switch(mode)
        case 1
            Ix=forward_diff(x,1,1);
            Iy=forward_diff(x,1,2);
        case 2
            Ix=back_diff(x,1,1);
            Iy=back_diff(x,1,2);
        otherwise
            Ix=central_diff(x,1,1);
            Iy=central_diff(x,1,2);
    end

    Ix2=Ix.^2;
    Iy2=Iy.^2;
    Ixy=Ix.*Iy;
    
    gmap = double(fspecial('gaussian',[3 3],1));
    Ix2 = conv2(Ix2,gmap,'same');
    Iy2 = conv2(Iy2,gmap,'same');
    Ixy = conv2(Ixy,gmap,'same');

    %calculate the eigenvalue 
    temp = sqrt((Ix2-Iy2).^2+4*Ixy.^2);

    u1 = (Ix2+Iy2 + temp)/2;
    u2 = (Ix2+Iy2 - temp)/2;   

    %calculate the present object function 
    switch method
        
        %%% CASE1: STV_1
        case 1
            output = lamda*(sqrt(abs(u1))+sqrt(abs(u2)));
            
        %%% CASE2: NCDR
        case 2
            u1 = abs(u1);
            u2 = abs(u2);
            alpha = sqrt(alpha);
            output = lamda*((sqrt(u1)+alpha).*(sqrt(u2)+alpha)./(eps+sqrt(u1)+alpha+sqrt(u2)+alpha));
            
    end
    output = sum(output(:));
end
