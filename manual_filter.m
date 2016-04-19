figure(1)
plot(date_time,z) %look at given data
xlabel('Time(s)','fontsize',20)
ylabel('Amplitude','fontsize',20)

%preform and plot DFT
sampleing_rate= 8; %sampling rate in Hz
l=length(z);
ftz=fft(z); %preform foward DFT
abs_fty=abs(ftz); %find absolute value
spectrum_freq=fourier_frequencies(sampleing_rate, l); %find freq
[~,order]=sort(spectrum_freq); %put in order bc negative freqs
figure (2)
plot(spectrum_freq(order),abs_fty(order)) %plot of dft
xlabel('Frequency(Hz)','fontsize',20)
ylabel('FFT amplitude','fontsize',20)

%find the max frequencie
[max_value,max1p]=max(abs_fty);
max1=spectrum_freq(max1p) %find the first max freq

%create a high pass filter to get rid of freq below cut off freq
re=1e-10; %correct for round off error
G1=ones(l,1);
G1(abs(spectrum_freq) < max1+re, 1)=0;
abs_fty_filter=abs(ftz.*G1);
filtered=ifft((ftz.*G1));
figure (3)
plot(spectrum_freq(order),abs_fty_filter(order))
xlabel('Frequency(Hz)','fontsize',20)
ylabel('FFT amplitude','fontsize',20)

%filtered and raw data
figure(4)
plot(date_time,z,'b:',date_time,filtered,'k-')
xlabel('Time(s)','fontsize',20)
ylabel('Amplitude','fontsize',20)
legend('raw data','filter')