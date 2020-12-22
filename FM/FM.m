%I intend to stimulate FM Modulation and Demodulation for a (recorded audio
%signal)message signal.
%I will be plotting the time domain Message signal, Time domain FM
%modulated signal, time domain FM Demodulated signal.
% and frequency domain message, FM  and Demodulated signals.
%First of all we clear all existing data.
clc;  %clear command window
clear all;  %clear our workspace
close all;  %closes all other workable windows

%% Generating message signal signal
[x,fs]=audioread('test_music.wav');  %We need to read the sampling frequency too otherwise might loose accuracy
ts=1/fs; % sampling time ie. 1/sampling frequency
fc = fs/10; %carrier frequency As we are changing it with respect to message signal. 
%We take amplitude of carrier signal as 1 for ease of computation.
df=1;%To keep it simple we take 1 (Frequency change Deviation) and see that things match.
m=x(:,1);   %both columns of x have same data so we use only 1 column in m.                     	
t = (0:ts:((size(m,1)-1)*ts))';  %Making t array from 0 to (m-1)*ts for m samples.
int_x = cumsum(m)/fs; %To get the cumulative sum of elements of input signal as vector. Works like a integrator.
%eg. cumsum([1 2 3]) will result in [1 3 6].
%Generating the modulated signal -----

%xfm =cos(2*pi*t(fc+Df*m))=cos(2*pi*fc*t)*cos(2*pi*m*t*Df)-sin(2*pi*fc*t)*sin(2*pi*m*t*Df)
xfm = cos(2*pi*fc*t).*cos(2*pi*fc*int_x*df)-sin(2*pi*fc*t).*sin(2*pi*fc*int_x*df); %FM Modulated signal
% xi=cos(2*pi*fc*int_x); %The i component of carrier wave
% xq=sin(2*pi*fc*int_x) ; %The q component of carrier wave.
t2 = (0:ts:((size(xfm,1)-1)*ts))';  %making time array to do use Hilbert transform .
%t2 = t2(:,ones(1,size(xfm,2)));
%--------demodulation using envelope detector------------------------%
%We use Hilbert transform. and differentiate the FM modulated signal to
%obtaing the message signal.
xfmq = hilbert(xfm).*exp(-j*2*pi*fc*t2);
z = (1/(2*pi*fc))*[zeros(1,size(xfmq,2));diff(unwrap(angle(xfmq)))*fs];
%-----------------------------------
%Plotting the time domain plots
figure;
subplot(311);   %To plot message signal in time domain.
plot(t,x,'g');
xlabel('time ');
ylabel('amplitude');
title("message signal in time domain.");
hold on;

subplot(312);  %To plot FM Modulated signal in time domain.
%The signal 
plot(t,xfm,'o');
xlabel('time ');
ylabel('amplitude');
title("FM Modulated Signal in time domain");
hold on;

subplot(313);
plot(t,z,'b');
xlabel('time ');
ylabel('amplitude');
title('Demodulated Signal in time domain');
ylim([-0.5 0.5]);
hold off;
%----------------------------------
%Writing the demodulated signal to a file.
audioFile='shivam.wav';	
audiowrite(audioFile, z, fs);
%----------------------------------------
%Plotting the frequency plots.

[MOD_x, mod1,df1]=fftseq((m)',ts,df); %I used the same variables to plot message,modulated,Demodulated signals.
f_x=[0:df1:df1*(length(mod1')-1)]-fs/2;
figure;
%Plotting the frequency domain plot of message signal
subplot(311);
plot(f_x,abs(fftshift(MOD_x)))
title('Magnitude spectrum of the message signal')
xlabel('Frequency')
ylabel('Magnitude');
hold on;
%Plotting the frequency domain modulated signal
%I have used the same variables for plotting all 3 frequency spectrum as
%otherwise it will need lots of variables. The ts is sampling time which is
%same for all 3.
[MOD_x, mod1,df1]=fftseq((xfm)',ts,df); %I used the same variables to plot message,modulated,Demodulated signals.
f_x=[0:df1:df1*(length(mod1')-1)]-fs/2;
subplot(312);
plot(f_x,abs(fftshift(MOD_x)))
title('Magnitude spectrum of the Modulated signal')
xlabel('Frequency')
ylabel('Magnitude');
hold on;
%Plotting the frequency domain demodulated signal
subplot(313);
[MOD_x, mod1,df1]=fftseq((z)',ts,df);
f_x=[0:df1:df1*(length(mod1')-1)]-fs/2;
plot(f_x,abs(fftshift(MOD_x)))
title('Magnitude spectrum of the demodulated signal')
xlabel('Frequency')
ylabel('Magnitude');
hold off;
