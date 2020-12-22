%I intend to stimulate AM Modulation and Demodulation for a sinusoidal
%message signal.
%I will be plotting the time domain Message signal, time domain Carrier signal, time domain Amplitude modulated signal
%time domain Amplitude Demodulated signal.
% and frequency domain Amplitude modulated and Demodulated signals.
%First of all we clear all existing data.
clc;  %clear command window
clear all;  %clear our workspace
close all;  %closes all other workable windows

%% Generating message signal signal
m = 1;   %Modulation Index we assume it 1 as it shall be less than or equal to 1 .
Am = 1;   % Amplitude of modulating signal (we take 1 Volt)to get normalized message signal.
fm = 10;   % Frequency of modulating (message) signal (we take 10 Hz)
fs = 100*fm;  % Sampling frequency we take 100 times the frequency of message signal 
                   % (to have it properly sampled.)
Tm = 1/fm;    % Time period of modulating signal which will be inverse of its frequency.
t = 0:1/fs:5*Tm;    % We stimulate 5 periods of modulating signal with interval of sampling time 
                           %which is 1/(sampling frequency)
ym = Am*sin(2*pi*fm*t);  % The generated message signal.
% %Parity check for message signal
% L = length(t);
% %Nf = 2^ceil(log2(L));    %This was not generating proper points for fft and were getting huge difference in message signal .
% Nf=L+1;            %This ensured us to reach good quality of message signal 
%                         %(frequency of peak close to 19.92 which is good precision in this part .)
% f_ym = fftshift(fft(ym,Nf));         %Shifting the signal to make it symmetric about 0 frequency
% f = (-Nf/2:1:Nf/2-1)*fs/Nf;
% figure;
% plot(f,abs(f_ym));
% xlabel("frequency (Hz)");
% ylabel("|m(t)|");
% title("Frequency response of message signal");

figure;
subplot(311);    %We will be plotting the time domain message signal, carrier signal and the modulated signal in same plot
plot(t,ym);  %Plotting the message signal
hold on;
xlabel("time (secs) -->");
ylabel(" m(t)(Volts) ");
title ('Time domain Message Signal');

%% Generating the carrier signal
Ac = Am/m;    % Amplitude of carrier signal is minimum magnitude of message signal(Am) / modulation index(m).
fc = 20*fm;   % Frequency of carrier signal (we assume it to be 20 times the frequency of message signal.)
yc = Ac*sin(2*pi*fc*t);    %The generated Carrier signal

subplot(312); 
hold on;
plot(t,yc); 
ylabel ('ycarrier(Volts)');
xlabel("time (secs) -->");
title ('Time Domain Carrier Signal');


%% Modulating message signal to carrier signal using AM modulation
%we generate time domain amplitude modulated signal as 
%AM=Ac[1+(molulation index)*m(t)]*sin(2pi*fc*t)=yc*(1+m*m(t))
AM = Ac*sin(2*pi*fc*t).*(1+m*sin(2*pi*fm*t)); 
subplot(313);
plot(t,AM,'r');
hold off;
xlabel ("time (secs) -->");
ylabel("AM(Volts)");
title ('time domain AM Signal');

%Converting time domain AM signal to frequency domain using fft.
L = length(t);   %To get number of points in t array.
%Nf = 2^ceil(log2(L));    %To get the approzimation for the closest power of 2 greater equal length of t.
    %(This makes further computations discrete without losing any value but
    %was giving high error and low precision.
Nf=L ; %This gave much better precision (L point F.T).
AM_fft = fftshift(fft(AM,Nf));     % shifting fft to get it for the period from -pi to +pi instead of the usual 0 to 2pi.
mf = fftshift(fft(ym,Nf));     % shifting fft to get it for the period from -pi to +pi instead of the usual 0 to 2pi.
cf = fftshift(fft(yc,Nf));     % shifting fft to get it for the period from -pi to +pi instead of the usual 0 to 2pi.
f = (-Nf/2:1:Nf/2-1)*fs/Nf;      %getting corresponging frequencies by dividing the interval (-fs/2,fs/2) in discrete parts. 

figure;
subplot(311);    %We will be plotting the frequency domain message signal, carrier signal and the modulated signal in same plot
plot(f,abs(mf));  %Plotting frequency response of message signal
hold on;
xlabel("Frequency (Hz) -->");
ylabel(" |m(f)| ");
title ('Frequency domain Message Signal');

subplot(312); 
hold on;
plot(f,abs(cf));   %Plotting frequency response of carrier signal
ylabel ('|c(f)|)');
xlabel("Frequency (Hz) -->");
title ('Frequency Domain Carrier Signal');

subplot(313);
plot(f,abs(AM_fft)); %Plotting frequency response of DSB SC molulated signal
title('Freq Response of AM Signal');
xlabel('frequency (Hz)');
ylabel(' |AM(F)|')
hold off;

% Demodulating the AM signal using Coherent Detection
% Step 1: Synchronous Demodulation using carrier
Vc = 2*AM.*sin(2*pi*fc*t);

%Step 2: Low Pass RC Filter we use Butterworth filter for that
[b,a] = butter(4,fc*2/fs);
ym_rec = filter(b,a,Vc); % filtering the demodulated signal
ym_rec=ym_rec- mean(ym_rec); %To get zero mean and low error in demodulation by subtracting mean from each of the terms


figure;
plot(t, ym_rec,'LineWidth',2);  %Plotting the demodulated message signal
hold on;
plot(t,ym,'r');   %plotting the origional message signal in the same plot 
title('demodulated AM signal with origional message signal');
legend("Demodulated AM signal","message signal");
xlabel('Time (s)');
ylabel('Amplitude (Volts)');

ym_rec_fft = fftshift(fft(ym_rec,Nf));              % Frequency Response of retrieved message signal ,
                                                              %we use the same number of points for fft
f = (-Nf/2:1:Nf/2-1)*fs/Nf;
figure;
subplot(211);
plot(f,abs(ym_rec_fft));
hold on;
title('Freq Response of demodulated AM signal y_m(t)');
xlabel('f(Hz)');
ylabel('|AM(F)|');

%To plot the frequency response of message signal to compare result
subplot(212);
hold on;
Nf=L;            %This ensured us to reach good quality of message signal 
                        %(frequency of peak close to 19.92 which is good precision in this part .)
f_ym = fftshift(fft(ym,Nf));         %Shifting the signal to make it symmetric about 0 frequency
f = (-Nf/2:1:Nf/2-1)*fs/Nf;
plot(f,abs(f_ym));
xlabel("frequency (Hz)");
ylabel("|m(f)|");
title("Frequency response of message signal m(t)");

