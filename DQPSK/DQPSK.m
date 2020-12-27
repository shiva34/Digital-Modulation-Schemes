%I intend to demonstrate DQPSK modulation and Demodulation with AWGN with
%unit mean and EbN0dB's varrying from 0-10 dB with gray labling and have plotted
%BER with Eb/No for stimulation and using Q function.
%I have taken 10^5  symbols in this experiment.
%In the code the integers{0,1,2,3} shall be treated as 2 bit binary as they both mean
%the same once converted using bi2de.

%First of all we clear all existing data.
clc;  %clear command window
clear all;  %clear our workspace
close all;  %closes all other workable windows

%generate BPSK constellation as complex numbers for gray code.
k=double(1.0)/double(sqrt(2)); %The normalizing factor
constellation=k*[1+1i -1+1i -1-1i 1-1i]; %To store constellation points ie. To map constellation points in complex double
%to 0 1 2 3 positions .as in below diagram.
%   01(1)  |  00(0)
%   11(3)  |  10(2)

%To map any 2 bit binary nmber to its constellation we will use its decimal
%equivalent number as index+1 of constellation array.
%Eg : For 01 the decimal number is 1 and constellation(1+1)=(-1+j)/K. which
%is the constellation point 2 .
%We take 1+1i as 0 phase, -1+1i as pi/2 phase, -1-1i as pi phase, 1-1i as 3pi/2 phase

%———Input Fields————————
ninputs = 10000; %  represents number of symbols used for stimulation. ie 10^5
EbN0dB = 0:0.01:10; % multiple Eb/N0 values from 0-10 dB in intervals of 0.01 for higher resolution
k=2; %Number of bits per symbol is 2
EsN0dB = EbN0dB + 10*log10(k); %To get the value of Es/No
%Generating ninputs random 2 bit symbols to use for DQPSK
for k=1:ninputs %Loop to generate 2 bit random inputs.
 input(k)= randi([0, (2^2-1)]); %randomly generates a 2 bit number between 0 and 3 including both of them.
end

%using differential encoding to get input phase change
phase=[0 1 3 2]; %It maps the input to its absolute phase.
%Eg Absolute phase of 11(3)  is
%pi/2*(phase(3+1))=2*pi/2=pi.
%Always we send the initial bit as 00 followed by our modulated signal.
input=[0 input]; %Adding a initial bit 0 in input
input_phase=zeros(1,ninputs+1); %To initialize the initial phase with 0.Here a value n will mean the differential phase of n*pi/2.
absolute_phase=phase(input+1); %Absolute phase of input to compare
for k=2:ninputs+1
    input_phase(k)=mod((input_phase(k-1)+phase(input(k)+1)),4);%To get the differential phase as lowest multiple of pi/2. as 4pi/2=2pi=0
end
input_mod=constellation(input_phase+1);%We then use the differential phase to map it to QPSK

number_snr = length(EbN0dB); %Number of EbN0dB values to check
perr_estimate = zeros(1,number_snr); %To estimate error for each EbN0dB value and add it to estimate
serr_estimate =  zeros(1,number_snr); %To estimate error for each EbN0dB value and add it to estimate

for k=1:number_snr %EbN0dB for loop
    EbN0dB_now = EbN0dB(k); %The current value of EbN0dB being tested for BER.
    ebno=10^(EbN0dB_now/10); %We convert EbN0dB from dB to decimal unit.
    sigma=sqrt(1/(ebno)); %The corresponding varience for noise.
    % add 2d Gaussian noise to our symbols.
    received = DQPSK_Noise(input_mod,sigma,ninputs+1); % To add complex WBGN noise to our input signal as we have a extra beginning symbol.
    decisions=zeros(1,ninputs+1); %We initialize decisions with zeros corresponding to all n symbols.
    for n=1:ninputs+1 %Symbol for loop to compute distance which is used to stimulate recieved signal using constellation points.
        
        distances = abs(received(n)-constellation); %It stores a vector of absolute distance 
                                                        %from each of the constellation points.
        [min_dist,decisions(n)] = min(distances); %We store the minimum of those distances with memory location (1 to 4)
                                                   %and get the input
                                                   %corresponding to that memory location.
    end
     
    decision_phase=decisions-1; %To make it between 0 to 3
    decoded_phase=zeros(1,ninputs+1);
    %For loop to get the absolute phase as a factor of pi/2
    for n=2:ninputs+1
        if decision_phase(n)>=decision_phase(n-1) %When the next term is greater or equal we can subtract directly,
                        %otherwise we will have to add 2Pi to it to make subtraction result positive and correct.
            decoded_phase(n)=(decision_phase(n)-decision_phase(n-1)); %This gives the differentially decoded phase
        else
            decoded_phase(n)=(4+decision_phase(n)-decision_phase(n-1)); %This is done to ensure decoding is done correctly,
               %even when the recieved phase was earlier rounded by removing 2pi terms so we add them back for decoding.
        end
    end
    
    decoded_symbol=phase(decoded_phase+1);%To get symbol from phase
    %To calculate the BER we use a function which converts both integer
    %strings to binary and compares the values.
    error=error_cal(decoded_symbol(2:end),input(2:end));  %We have the initial 0 which was not in origional signal . 
    perr_estimate(k) =perr_estimate(k)+ sum(error)/(ninputs); %This gives BER .
    
    sym_err=(decoded_symbol(2:end) ~= (input(2:end)));  %To get symbol error rate 
    serr_estimate(k) =serr_estimate(k)+ sum(sym_err)/ninputs; %This gives SER .
end

%Plotting the data
%To plot BER in Eb/N0
figure
semilogy(EbN0dB,perr_estimate); %To plot the BER per ninputs with EbN0dB.
hold on; %To add both data in the same plot
semilogy(EbN0dB,2*qfunc((sqrt(10.^(EbN0dB/10))))); % To plot BER theoretical using Q-function .
legend("Experimental BER ","Theoretical using Q function"); %To add legend
xlabel("Eb/N0 (dB)"); %To add EbN0dB label to x axis
ylabel("BER (Bit Error Rate) "); %To add BER label to y axis. its BER per symbol.
title("BER plot for "+string(ninputs)+" input symbols.");

%To plot symbol error rates
figure;
semilogy(EsN0dB,serr_estimate); %To plot the BER per ninputs with SNR.
hold on; %To add both data in the same plot
semilogy(EsN0dB,2*qfunc(sqrt((10.^(EbN0dB/10))))); % To plot BER theoretical using Q-function .
legend("Experimental SER ","Theoretical using Q function"); %To add legend
xlabel("Es/No(dB)"); %To add SNR label to x axis
ylabel("SER (Symbol Error Rate .)"); %To add BER label to y axis. its BER per symbol.
title("SER plot for "+string(ninputs)+" input symbols.");
