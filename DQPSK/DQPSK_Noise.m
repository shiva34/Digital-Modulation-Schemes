function [output] = DQPSK_Noise(input_mod,sigma,ninputs)
%This function adds real and complex Gaussian noise with 0 mean and
%Variance dependent on Sigma.
%   input_mod is the input signal to which complex noise needs to be added.
%  Nbit tells the number of indexes shall be used to add noise. (Usually
%  that shall be lenght of input_mod ) but if we want to return a higher
%  length signal we can give a higher value too.
%  Sigma is the factor we multiply the unit variance noise.
sigma=sigma/sqrt(2); %To make it suitable for normalized constellation points..
output = input_mod + sigma*randn(1,ninputs)+j*sigma*randn(1,ninputs); % To add complex WBGN noise to our input signal as row vector.
end

