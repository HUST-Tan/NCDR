function output = f_obs_gradient_diff_select( x, y, lamda, alpha, method, mode, NL_flag )
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
    
    global W;
    if ~NL_flag
        gmap = double(fspecial('gaussian',[3 3],1));
        Ix2 = conv2(Ix2, gmap, 'same');
        Iy2 = conv2(Iy2, gmap, 'same');
        Ixy = conv2(Ixy, gmap, 'same');
    else
        Ix2(:) = W*Ix2(:);
        Iy2(:) = W*Iy2(:);
        Ixy(:) = W*Ixy(:);
    end

    %calculate the eigenvalue 
    temp = sqrt((Ix2-Iy2).^2+4*Ixy.^2);

    u1 = (Ix2+Iy2 + temp)/2;
    u2 = (Ix2+Iy2 - temp)/2;      
    %calculate the eigenvector
    v11 = 2*Ixy;
    v12 = Iy2 - Ix2 +temp;
    frac = sqrt(v11.^2+v12.^2+eps);
    v11 = v11./frac;    %     v21 = -v12;
    v12 = v12./frac;    %     v22 = v11;
    
    %calculate the gradient of the object function to determine the search direction
    switch method
        
        %%% CASE1: STV_1
        case 1
            temp1 = sqrt(u1+eps);
            temp2 = sqrt(u2+eps);
            j11 = (v11.^2)./temp1 + (v12.^2)./temp2;
            j22 = (v12.^2)./temp1 + (v11.^2)./temp2;
            j12 = (v11.*v12)./temp1 + ((-v12).*v11)./temp2;   
            
        %%% CASE2: NCDR
        case 2
            u1 = sqrt(abs(u1)) + sqrt(alpha);
            u2 = sqrt(abs(u2)) + sqrt(alpha);
            temp1 = (u2.^2)./(((u1+u2).^2).*(u1 - sqrt(alpha) + eps ));
            temp2 = (u1.^2)./(((u1+u2).^2).*(u2 - sqrt(alpha) + eps ));
            j11 = (v11.^2).*temp1 + (v12.^2).*temp2;
            j22 = (v12.^2).*temp1 + (v11.^2).*temp2;
            j12 = (v11.*v12).*temp1 + ((-v12).*v11).*temp2; 
            
    end

    if ~NL_flag
        j11 = conv2(j11,gmap,'same');
        j22 = conv2(j22,gmap,'same');
        j12 = conv2(j12,gmap,'same');
    else
        j11(:) = W*j11(:);
        j22(:) = W*j22(:);
        j12(:) = W*j12(:);
    end
    
    term1 = j11.*Ix+j12.*Iy;
    term2 = j22.*Iy+j12.*Ix;
    switch(mode)
        case 1
            div_term = back_diff(term1,1,1) + back_diff(term2,1,2);
        case 2  
            div_term = forward_diff(term1,1,1) + forward_diff(term2,1,2);
        otherwise
            div_term = central_diff(term1,1,1) + central_diff(term2,1,2);
    end
    
    output = (x - y - lamda*div_term);
end


