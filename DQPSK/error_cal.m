function error = error_cal(decisions_bin,input)
%This function finds the bit error and returns that array
%   It takes integer input and converts them to binary to compare and find
%   the bit errors per word.
%It will count the number of bits that do not match for each position of
%both the arrays.
for s=1:length(input)
    d_bin=de2bi(decisions_bin(s),2); %To get a zero padded 2 bit binary string for ease of comparing.
    i_bin=de2bi(input(s),2);  %To get a zero padded 2 bit binary string for ease of comparing.
    biterror=0;   %To count error per bit
    for t=1:2
        if d_bin(t)~=i_bin(t)
            biterror=biterror+1;  %adding error for each incorrectly decieded bit.
        end
        num(s)=biterror; %To store the total bit error for each word 
    end
end
error=num;
end

