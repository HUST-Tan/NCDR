function out = central_diff( data,step,dim )
%CENTRAL_DIFF Summary of this function goes here
%   Detailed explanation goes here   
    [m n r]=size(data);
    SIZE=[m,n,r];
    position = ones(1,3);
    temp1 = zeros(SIZE+2);
    temp2 = zeros(SIZE+2);
    
    position = position + 1;
    SIZE = SIZE +1;
    temp1(position(1):SIZE(1),position(2):SIZE(2),position(3):SIZE(3))=data;
    temp2(position(1):SIZE(1),position(2):SIZE(2),position(3):SIZE(3))=data;
    
    SIZE(dim)=SIZE(dim)-1;    
    position(dim)=position(dim)-1;
    temp1(position(1):SIZE(1),position(2):SIZE(2),position(3):SIZE(3))=data;
    
    SIZE(dim)=SIZE(dim)+2;    
    position(dim)=position(dim)+2;
    temp2(position(1):SIZE(1),position(2):SIZE(2),position(3):SIZE(3))=data;
    
    temp1 = (temp1-temp2)/2/step;
    SIZE(dim)=SIZE(dim)-1;    
    out = temp1(2:SIZE(1),2:SIZE(2),2:SIZE(3));
%    out = back_diff(data,step,dim);
end

