%This function takes in input as s1, s2, K
%#To compute DSB SC Modulation with it we need to give time domain Message in s1, Carrier signal in s2 with
    %modulating index in K(Scaling Constant) which returns the product which is DSB SC Modulated Signal. . 
%#To get the DSB SC Demodulated signal with some high frequency components we need to give
    %modulated signal(in s1) and carrier signal(in s2) with 2(in K ie. Scaling
    %Constant) to get their product .
function Product = DSBSC(s1,s2,K)  %The input denote signal 1, signal 2 and scaling constant. 
    Product = K*s1.*s2;    %%The product of message and carrier signal with modulating index is returned.
                             
end

