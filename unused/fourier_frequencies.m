function spectrum_freq=fourier_frequencies(SampleRate, N)
	%% return column vector of positive and negative frequencies for DFT
	% SampleRate - acquisition rate in Hz
	% N - number of data points

	f1=SampleRate/N; % fundamental frequency = SampleRate*N

	% simple assignment of frequency
	spectrum_freq=(((1:N)-1)*f1).';  % column vector

	% recall spectrum(1) is zero frequency i.e. DC part
	NyquistFreq= (N/2)*f1; % index of Nyquist frequency i.e. reflection point

	%let's take reflection into account
	spectrum_freq(spectrum_freq>NyquistFreq) =-N*f1+spectrum_freq(spectrum_freq>NyquistFreq);
end