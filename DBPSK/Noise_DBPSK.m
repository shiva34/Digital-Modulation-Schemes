function [output] = Noise_DBPSK(input_mod,Nbit,sigma)
%This function adds real and complex Gaussian noise with 0 mean and
%Variance dependent on Sigma.
%   input_mod is the input signal to which complex noise needs to be added.
%  Nbit tells the number of indexes shall be used to add noise. (Usually
%  that shall be lenght of input_mod ) but if we want to return a higher
%  length signal we can give a higher value too.
%  Sigma is the factor we multiply the unit variance noise.
output = input_mod + sigma*randn(Nbit,1)+j*sigma*randn(Nbit,1); % To add complex WBGN noise to our input signal as a column vector.
end

