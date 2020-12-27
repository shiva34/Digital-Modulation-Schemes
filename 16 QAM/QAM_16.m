%I intend to demonstrate 16 QAM modulation and Demodulation with AWGN with
%unit mean and SNR's varrying from 0-10 dB with gray labling and without gray labeling.
% I then added the AWGN with unit mean and compare it with
%constellation.
%I have taken 10^5 and 10^6 bits of signal in this experiment.

%First of all we clear all existing data.
clc;  %clear command window
clear all;  %clear our workspace
close all;  %closes all other workable windows

%generate 16 QAM constellation as complex numbers
b = 4; %Number of bits in a symbol (its even)
M = 2^b; %Number of points in constellation=2^4=16
%As we have 4X4 constellation which is symmetric we can simply choose
%points -3 ,-1, 1, 3 .
x1 = -(b-1):2:(b-1);%As we have b symbols b/2 to the left of 0 and b/2 to the right of zero. 
constellation = x1 + 1i*x1.';  %To add real and complex values
k=double(1.0)/double(sqrt(10)); %The normalizing factor
constellation=k*constellation; %Normalising the constellation making it unit power.

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
 
ninputs = 1000; % represents number of symbols used for stimulation.
input=zeros(1,ninputs);
for k=1:ninputs %Loop to generate 4 bit random inputs.
 input(k)= randi([0, (2^4-1)]); %randomly generates a 4 bit number between 0 and 15 including both of them.
end
binc=constellation(input(:)+1); %will have the constellation symbols for non gray
input_gray=gre(input(:)+1);%will get the corresponding gray input for the same constellation input.

snr = 0:0.1:10; %We change SNR from 0-10 dB.
%We assume the input signal to be all points in inputc. 
decisions_bin = zeros(1,ninputs);
number_snrs = length(snr); %Number of snr values to check
berr_estimate = zeros(number_snrs,1); %To estimate BER error for each SNR value and add it to estimate
berr_estimate_gray = zeros(number_snrs,1); %To estimate BER error for each SNR value and add it to estimate

%The stimulation begins.
for k=1:number_snrs %SNR for loop
    snr_now = snr(k); %The current value of snr being tested for BER.
    ebno=10^(snr_now/10); %We convert snr from dB to decimal unit.
    sigma=sqrt(1/(ebno)); %The corresponding varience for noise.
    % add 2d Gaussian noise to our symbols.
    receivedbin = binc+ (sigma*randn(ninputs,1)+j*sigma*randn(ninputs,1))/sqrt(10);% add complex WBGN noise to our input signal  with proper scaling.
    decisions=zeros(ninputs,1); %I initialized decisions with zeros corresponding to all n symbols.
    for n=1:ninputs 
        
        distancesbin = abs(receivedbin(n)-constellation); %calculating absolute distance of every signal point from each point of constellation.
        [min_dist_bin,decisions_bin(n)] = min(distancesbin(:)); %The minimum distance constellation point is the signal.
    end
   
  
    decisions_gray=gre(decisions_bin); %We map the decoded signal back to gray code input to compare error for gray.
    %The decisions_bin are index values while they correspond to some
    %decisions_gray value.
    decisions_bin=decisions_bin-1; %To make it from 0 to 15.
    
    %To calculate bit error
    num=zeros(1,ninputs);%For faster code
    for s=1:length(input)
        d_bin=de2bi(decisions_bin(s),4); %To get a zero padded 4 bit binary string for ease of comparing.
        i_bin=de2bi(input(s),4);  %To get a zero padded 4 bit binary string for ease of comparing.
        biterror=0;   %To count error per bit
        for t=1:4
            if d_bin(t)~=i_bin(t)
                biterror=biterror+1;  %adding error for each incorrectly decieded bit.
            end
            num(s)=biterror; %To store the total bit error for each word 
        end
    end
    error=num; %To get bit error array for non - morse encoded signal.
    
    for s=1:length(input_gray)
        d_bin=de2bi(decisions_gray(s),4); %To get a zero padded 4 bit binary string for ease of comparing.
        i_bin=de2bi(input_gray(s),4);  %To get a zero padded 4 bit binary string for ease of comparing.
        biterror=0;   %To count error per bit
        for t=1:4
            if d_bin(t)~=i_bin(t)
                biterror=biterror+1;  %adding error for each incorrectly decieded bit.
            end
            num(s)=biterror; %To store the total bit error for each word 
        end
    end
    error_gray=num; %To get bit error array for morse encoded signal.
    
    berr_estimate(k) =berr_estimate(k)+ sum(error)/ninputs; %This gives BER .
    berr_estimate_gray(k) =berr_estimate_gray(k)+ sum(error_gray)/ninputs; %This gives BER per symbol. 

end

%Plotting the BER(Bit Error Rate.)
figure;
semilogy(snr,berr_estimate); %To plot the BER per ninputs with SNR.
hold on; %To add both data in the same plot
semilogy(snr,berr_estimate_gray); %To plot the BER per ninputs with SNR.
hold on;
%As for 16 QAM the average number of neighbours is 3 we multiply Qfunc by 3
semilogy(snr,3*qfunc(sqrt((10.^(snr/10))))); % To plot BER theoretical using Q-function .
legend("Experimental BER ","Experimental BER with gray code","Theoretical using Q function"); %To all legend
xlabel("SNR (dB)"); %To add SNR label to x axis
ylabel("BER (Bit Error Rate .)"); %To add BER label to y axis. its BER per symbol.
title("BER plot for 16 QAM");

