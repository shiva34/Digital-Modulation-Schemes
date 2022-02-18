%Demonstration BPSK modulation and Demodulation with AWGN with
%unit mean and SNR's varrying from 0-10 dB .

%We take the input signal as -1 everytime to make implementation a little
%faster. We then add the AWGN with unit mean and compare it with -1 if its
%closer to 1 we have a bit error and count all such errors for all values of
%SNR. We have taken 10^5 and 10^6 bits of signal in this experiment.
%We have not used any modules to hope for faster implementation of code.

clc;
clear all;
close all;

%generate BPSK constellation as complex numbers
numBits = 10^6;
rBits = rand(numBits, 1)>0.5;
constellation = myModulator(rBits);

%number of symbols in simulation
nsymbols = length(constellation); %Change it to 10,00,000 > represents number of symbols used for stimulation.
snr = 0:0.01:10; %We change SNR from 1-10 dB.

%We assume the input signal to be -1 for all symbols.
number_snrs = length(snr); %Number of snr values to check
perr_estimate = zeros(number_snrs,1); %To estimate error for each SNR value and add it to estimate

for k=1:number_snrs %SNR for loop
    snr_now = snr(k); %The current value of snr being tested for BER.
    ebno=10^(snr_now/10); %We convert snr from dB to decimal unit.
    sigma=sqrt(1/(ebno)); %The corresponding varience for noise.
    % add 2d Gaussian noise to our symbols.
    received = constellation + sigma*randn(nsymbols,1)+1i*sigma*randn(nsymbols,1);
    decisions = myDemodulator(nsymbols, constellation, received);
    
    %change decision back to bits
    for d=1:length(decisions)
        if(decisions(d)~=1)
            rxBits(d) = 1;
        else 
            rxBits(d) = 0;
        end
    end
    errors = (rxBits'~=rBits);
    perr_estimate(k) = sum(errors)/nsymbols; %This gives BER per symbol.
end
semilogy(snr,perr_estimate); %To plot the BER per nsymbols with SNR.
hold on; %To add both data in the same plot
semilogy(snr,qfunc(sqrt(10.^(snr/10)))); % To plot BER theoretical using Q-function .
legend("Experimental BER ","Theoretical using Q function"); %To all legend
xlabel("SNR (dB)"); %To add SNR label to x axis
ylabel("BER (Bit Error Rate)"); %To add BER label to y axis. its BER per symbol.
