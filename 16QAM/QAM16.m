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
ninputs=1000;
 gre=[0 1 3 2 4 5 7 6 12 13 15 14 8 9 11 10]; %This is used to map between non - gray and gray constellation points.
 
 %calling modulator
[constellation, binc,input_gray,input] = myModulator(b,ninputs);

snr = 0:0.1:10; %We change SNR from 0-10 dB.
%We assume the input signal to be all points in inputc. 
decisions_bin = zeros(1,ninputs);
number_snrs = length(snr); %Number of snr values to check
berr_estimate = zeros(number_snrs,1); %To estimate BER error for each SNR value and add it to estimate
berr_estimate_gray = zeros(number_snrs,1); %To estimate BER error for each SNR value and add it to estimate
ser_estimate = zeros(number_snrs,1);
%The stimulation begins.
for k=1:number_snrs %SNR for loop
    snr_now = snr(k); %The current value of snr being tested for BER.
    ebno=10^(snr_now/10); %We convert snr from dB to decimal unit.
    sigma=sqrt(1/(ebno)); %The corresponding varience for noise.
    % add 2d Gaussian noise to our symbols.
    receivedbin = binc+ (sigma*randn(ninputs,1)+1i*sigma*randn(ninputs,1))/sqrt(10);% add complex WBGN noise to our input signal  with proper scaling.
    [decisions_gray,decisions_bin] = myDemodulator(receivedbin,constellation,ninputs,gre);
    
    %To calculate bit error
    num=zeros(1,ninputs);
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
    
    err = (decisions_gray~=input_gray);
    ser_estimate(k) = sum(err)/ninputs;
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
figure;
semilogy(snr,ser_estimate); %To plot the BER per ninputs with SNR.

hold on;
semilogy(snr,3*qfunc(sqrt((10.^(snr/10))))); % To plot BER theoretical using Q-function .
legend("Theoritacal SER","Q function  SER "); %To all legend
xlabel("SNR (dB)"); %To add SNR label to x axis
ylabel("SER (symbol Error Rate .)"); %To add BER label to y axis. its BER per symbol.
title("SER plot for 16 QAM");
