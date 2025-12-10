
function four(ft)
nT=length(ft);
for k=1:nT
tT(k)=sum(ft(1:k));      % 'sample times' of T
end
ft=60./(ft-mean(ft));
Fs  = 4;                    % sample frequency
ts  = 1:1/Fs:(tT(nT)); % new sample times
Ts  = interp1(tT,ft,ts); % resampled T
nTs = length(Ts);
% -- Fourier analysis
NFFT = 2^nextpow2(nTs);
Y    = fft(Ts,NFFT);
f    = Fs/2*linspace(0,1,NFFT/2);
% -- Hanning window
L        = 60*Fs;           % length (60s) of subset on which FFT is calculated
window   = hann(L);         % standard Hanning window
noverlap = 0.5*L;           % 75% overlap
S        = spectrogram(Ts-mean(Ts),window,noverlap,NFFT,Fs);
Smean    = mean(abs(S'));     % mean amplitude over time
Spower   = mean(abs(S').^2);  % power of mean amplitude over time
size(Spower(1:end-1));
figure
plot(f,Spower(1:end-1))
xlabel('Frequency (Hz)','FontSize',16)
ylabel('PSD T_{cycle}','FontSize',16)
xlim([0,1.5])