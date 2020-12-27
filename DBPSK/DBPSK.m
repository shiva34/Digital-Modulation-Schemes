%AIM: TO modulate and demodulate DBPSK signals an plot BER with
%theoretical values with Eb/No and Es/No.
%For that I generated some random bits and then initially do normal BPSK .
%Later I used the past modulated bits and current bit to get the
%differential signal. In BPSK the two differences are 0 and pi , that
%will lead to no change in phase or phase becoming negative. So we can
%simply change the initial binary signal to make that happen . ie. we send
%a bit 0 when no change in phase is there and bit 1 when phase change is
%there. since we got only 2 phases we can directly map them to 0 or 1.

%First of all we clear all existing data.
clc;  %clear command window
clear all;  %clear our workspace
close all;  %closes all other workable windows

%———Input Fields————————
Nbit = 1e3; % number of bits ie 10^5
EbN0dB = 0:0.01:10; % multiple Eb/N0 values
k=1; %Number of bits per symbol
EsN0dB = EbN0dB + 10*log10(k); %Here EbN0dB will be equal to EsN0dB
%generate BPSK constellation as complex numbers
a=[ones(1,1);zeros(1,1)];  %To make a=[0 1]'
constellation = exp(i*2*pi.*a/2); %To store constellation points ie. 1+0j and -1+0j in complex double

%-------Input signal----------
input=randi([0, 1], 1,Nbit);

%—generating differential symbols
%Initially we transmit 0 and then use the input bits and current input to get the differential symbols
mod=zeros(1,Nbit+1); %To define the size of differential symbols and initializing all with 0.
for i=1:Nbit
    mod(i+1)=xor(mod(i),input(i)); %To take xor of past signal with current input. %This will only change 0 and 1 from xnor.
                                     %For same phase absolute phase xor will return value 0 while for
                                     %change in absolute phase it will
                                     %return value 1. (No difference from xnor in terms of concept.just 1 will be replaced by 0)
end
%For example: if past signal was 0 and current input is 1 then there is a
%phase change of pi so we will send 1 . while if the current input is also
%0 then the phase change is 0 and we will send 0.
Nbit=Nbit+1;
%--------Input constellation---------
%This makes gives the phase difference of pi for 0 and 1 bits.
input_mod=constellation(mod+1); %this modulated signal is transmitted.

length_snr=length(EbN0dB); %To get the total number of snr values. ie Eb/No in (dB)
perr_estimate=zeros(1,length_snr);%Defining the size of error per snr initially for faster execution
for x = 1:length_snr %For loop to compute BER for each snr value

    %Adding noise with variance according to the required Es/N0
    snr_now = EbN0dB(x); %The current value of snr being tested for BER.
    ebno=10^(snr_now/10); %We convert EsNOdB from dB to decimal unit to get Standard deviation for AWGN Noise.
    sigma=sqrt(1/(ebno)); %The corresponding varience for noise.

    %Creating a complex noise for adding with DBPSK modulated signal
    % We add 2d Gaussian noise to our symbols using Noise_DBPSK function.
    %received=input_mod; %This was just used to test system no noise.
    received = Noise_DBPSK(input_mod,Nbit,sigma); % To add complex WBGN noise to our input signal.
    decisions=zeros(1,Nbit); %We initialize decisions with zeros corresponding to all symbols.
    for n=1:Nbit %Symbol for loop to compute distance which is used to stimulate recieved signal being 1 or -1.
        distances = abs(received(n)-constellation); %It stores a vector of absolute distance 
                                                        %from each of the constellation points 1 and -1.
        [min_dist,decisions(n)] = min(distances); %We store the minimum of those distances with memory location 
                                                   %(which will be 1 if the point is closer to the constellation point1
                                                   %and 2 if the point is closer to the constellation point -1.)
    end
    %Next we Ensure that incorrect decision values are replaced with correct
    %values so that we get the correct encoded binary string which can be
    %differentially decoded to get the result.
    for n=1:Nbit   %We know that value of 1 is decisions correspond to recieved signal being -1 (or 0in binary)so we replace that with 0.
                        
       if decisions(n)==1
           decisions(n)=0;  %This will replace all 1 values with 0 , since its BPSK we can only have 1 or -1 as symbols but we recover back the binary encoded.
       end
    end
    for n=1:Nbit   %We know that value of 2 is decisions correspond to recieved signal being 1 so we replace that with 1.
       if decisions(n)==2
           decisions(n)=1;  %This will replace all 2 values with 1 , which is the encoded binary.
       end
    end
    
    %To differentially Decode the string using another loop and xor gate.
    decoded=zeros(1,Nbit); %To define the size of differential symbols and initializing all with 0.
    for d=2:Nbit
        decoded(d)=(xor(decisions(d),decisions(d-1))); %It compares past decided binary character with current character to get the decoded character.
    end %For example : if current decided character is 1 and previous was 0 then the decoded string shall have 1 . 
    decoded=decoded(2:end); %As the starting character of transmitted string was 0 (System initialization)it was not part of origional signal so we remove that.
    
    errors = (decoded ~=input ); %All decoded bits different from input are errors 
                                 %and stored in errors.
    
    perr_estimate(x) = sum(errors)/Nbit; %This gives BER.
end


%—————Plotting commands———————–
%using Eb/No (dB)
figure
semilogy(EbN0dB,perr_estimate); %To plot the BER per nsymbols with SNR as Eb/No.
hold on; %To add both data in the same plot
semilogy(EbN0dB,qfunc(sqrt(10.^(EbN0dB/10)))); % To plot BER theoretical using Q-function .
legend("Experimental BER ","Theoretical using Q function"); %To all legend
xlabel("snr as Eb/N0(dB)"); %To add SNR label to x axis
ylabel("BER (Bit Error Rate)"); %To add BER label to y axis. its BER per symbol.
title("DBPSK Bit Error Plot with Eb/N0 using "+string(Nbit-1)+"bits") %As we added 1 to Nbit but actually used 1 less bit
hold off;

%Using Es/No (dB) will be same as that of EB/No as a symbol of DBPSK has only 1 bit
%in DBPSK . So both are equal.
figure
semilogy(EsN0dB,perr_estimate); %To plot the BER per nsymbols with SNR as Es/No.
hold on; %To add both data in the same plot
semilogy(EsN0dB,qfunc(sqrt(10.^(EsN0dB/10)))); % To plot BER theoretical using Q-function .
legend("Experimental BER ","Theoretical using Q function"); %To all legend
xlabel("snr as Es/N0(dB)"); %To add SNR label to x axis
ylabel("BER (Bit Error Rate)"); %To add BER label to y axis. its BER per symbol.
title("DBPSK Bit Error Plot with Es/N0 using "+string(Nbit-1)+"bits") %As we added 1 to Nbit but actually used 1 less bit
hold off;
