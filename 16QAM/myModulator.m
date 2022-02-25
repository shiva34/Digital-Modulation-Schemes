function [constellation, binc,input_gray,input] = myModulator(b,ninputs)
    %As we have 4X4 constellation which is symmetric we can simply choose
    %points -3 ,-1, 1, 3 .
    x1 = -(b-1):2:(b-1);%As we have b symbols b/2 to the left of 0 and b/2 to the right of zero. 
    constellation = x1 + 1i*x1.';  %To add real and complex values
    k=double(1.0)/double(sqrt(10)); %The normalizing factor
    constellation=k*constellation; %Normalisibbb               ng the constellation making it unit power.
    
    %mapping for non gray code in constellation (binary to decimal are mapped
    %by same position in array starting from bottop left corner being the
    %element at index 1.
    %   in binary                          in decimal
    %    0011  0111  1011  1111      |    3  7  11  15
    %    0010  0110  1010  1110      |    2  6  10  14
    %    0001  0101  1001  1101      |    1  5  9   13 
    %    0000  0100  1000  1100      |    0  4  8   12
    
    %mapping for gray code in the constellation
    %   in binary                          in decimal
    %    0010  0110  1110  1010      |    2  6  14  10
    %    0011  0111  1111  1011      |    3  7  15  11
    %    0001  0101  1101  1001      |    1  5  13  9
    %    0000  0100  1100  1000      |    0  4  12  8
    
    %so we map them using array
    gre=[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]; %This is used to map between non - gray and gray constellation points.
    
    input=zeros(1,ninputs);
    for k=1:ninputs %Loop to generate 4 bit random inputs.
     input(k)= randi([0, (2^4-1)]); %randomly generates a 4 bit number between 0 and 15 including both of them.
    end
    binc=constellation(input(:)+1); %will have the constellation symbols for non gray
    input_gray=gre(input(:)+1);%will get the corresponding gray input for the same constellation input.
end