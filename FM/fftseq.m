%This function computes the fft and does zero padding as per the input.
%Source : Mathworks .
function [M,m,df]=fftseq(m,ts,df) 
%       [M,m,df]=fftseq(m,ts,df)
%       [M,m,df]=fftseq(m,ts)
%FFTSEQ     generates M, the FFT of the sequence m.
%       The sequence is zero padded to meet the required frequency resolution df.
%       ts is the sampling interval. The output df is the final frequency resolution.
%       Output m is the zero padded version of input m. M is the FFT.
fs=1/ts;
if nargin == 2
  n1=0;
else
  n1=fs/df;
end
n2=length(m);
n=2^(max(nextpow2(n1),nextpow2(n2)));
M=fft(m,n);
m=[m,zeros(1,n-n2)];
df=fs/n;
