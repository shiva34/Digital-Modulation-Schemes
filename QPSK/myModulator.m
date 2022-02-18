function [ inputc, input_gray, constellation ] = myModulator (input)
    %generate QPSK constellation as complex numbers
    k=double(1.0)/double(sqrt(2)); %The normalizing factor
    constellation=k*[1+1i -1+1i -1-1i 1-1i]; %To store constellation points ie. 1+1j , 1-1j ,  -1-1j , -1+1j in complex double
    gre=[0 1 3 2]; %This is used to map between non - gray and gray constellation points.
    %number of symbols in simulation   
    
    inputc=constellation(input(:)+1); %will have the constellation symbols for non gray
    input_gray=gre(input(:)+1);%will get the corresponding gray input for the same constellation input.
    inputc=inputc.'; %Taking non conjugate transpose of input signal
end