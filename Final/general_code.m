% The general function 

clc;
clear 
close all

% the type of MODULATION
mod_type = '4QAM';
burst = 1;
% Number of bits
inp_bits = 90000;
%setting no. of bits stored in one symbol
if strcmp(mod_type,"BPSK")
    M=1;
elseif strcmp(mod_type,"4QAM")
    M=2;
elseif strcmp(mod_type,"16QM")
    M=4;
end

% Creating the bit stream to transmit);
TxBits = randi([0, 2^M-1],inp_bits,1);

%no. of repeatation
num_reps = 3;


% Calling the Repeator function
rep_Txbits = myRepeater(TxBits,num_reps);
len = length(rep_Txbits);
parts = 9;
% if rem(len,parts)~= 0
%     r = zeros((parts-rem(len,parts)),1);
%     rep_Txbits = [rep_Txbit002s r];
% end
inter_bits = myInterlever(rep_Txbits,parts);
 %in modulator tak%     
 %for x = 1000:2000
%         noise(x)= 5*sigma*(randn(1,1)+1i.*randn(1,1));
%     end
%     for x = 3000:5000
%         noise(x)= 10*sigma*(randn(1,1)+1i.*randn(1,1));
%     end
%ing the inputs as the bit stream and type of modulation to perform
mod_Sym = myModulator(inter_bits,mod_type);
mod_Txbits = myModulator(rep_Txbits,mod_type);
num_sym = length(mod_Sym);

%taking range of snr
snr = 0:0.1:10; 

lenghth_snrs = length(snr);

%creating vector to store errors);
error_estimate = zeros(lenghth_snrs,1);
bit_error = zeros(lenghth_snrs,1);
%  noise generation
noise=zeros(num_sym,1);


for k=1:lenghth_snrs 
    snr_now = snr(k);

    % Converting the db to decimal
    ebno=10^(snr_now/10);

    % generalising the noise for the BPSK type
    
    % defining the std deviation/variance for the different modulation  
    if strcmp(mod_type,"BPSK")
        sigma=sqrt(1/(1*ebno)); 
    elseif strcmp(mod_type,"4QAM")
        sigma=sqrt(1/(2*ebno)); 
    elseif strcmp(mod_type,"16QM")
        sigma=sqrt(1/(4*ebno)); 
    end
      
    % Defining Noise for all type of modulation
    noise = sigma*(randn(num_sym,1)+1i.*randn(num_sym,1));
    ns = noise;
    if burst == 1
        for x = 1000:2000
            noise(x)= 5*sigma*(randn(1,1)+1i.*randn(1,1));
        end
        for x = 3000:5000
            noise(x)= 10*sigma*(randn(1,1)+1i.*randn(1,1));
        end
    end
    % Adding noise to symbols.
    received_signal = mod_Sym + ns';
    recieved_signal_wi = mod_Txbits + noise';

    % Calling the demodulator function 
    demod_rxBits = myDemodulator(received_signal,num_sym,mod_type);
    Rxbits_wi = myDemodulator(recieved_signal_wi,num_sym,mod_type);
    %deinterlever 
    deleav = Deinterleaver(demod_rxBits,parts);
    % calling derepeater function to get same no. of symbols back.

    rxBits_dereps1 = myDerepeater(deleav,num_reps,inp_bits);
    rxBits_deepet = myDerepeater(Rxbits_wi,num_reps,inp_bits);
    % To estimate error for each SNR value and puttinf it in estimate
    errors1 = (rxBits_dereps1 ~= TxBits);
    errors = (rxBits_deepet~= TxBits);
    % Getting the Bit Error Rate for every symbol and then summing it
    
    error_estimate1(k) = sum(errors1)/num_sym;
    bit_error1(k) = error_estimate1(k)/M;
    
    error_estimate(k) = sum(errors)/num_sym;
    bit_error(k) = error_estimate(k)/M;
end   

% Plotting the error obtained from demodulation and the theoretical

semilogy(snr,bit_error1);

hold on;
disp(error_estimate1);

semilogy(snr,bit_error);

disp(error_estimate);

% Plotting the BER using the q-function for different type of modulation
% if strcmp(mod_type,"16QM")
%     semilogy(snr,3*qfunc(sqrt(0.2*10.^(snr/10)))); 
%    
% elseif strcmp(mod_type,"4QAM")
%     semilogy(snr,2*qfunc(sqrt(10.^(snr/10))));
%     
% elseif strcmp(mod_type,"BPSK")
%     semilogy(snr,qfunc(sqrt(10.^(snr/10)))); 
% end

legend("BER from noise(experimental) "); 
xlabel("SNR");
ylabel("bits Error Rate");    

