% amplitude clipping of OFDM signal
% awgn
% lteSymbolDemodulate(rx_data,modulation,'Hard');
clear all;close all;clc

disp('b = 1 BPSK;b = 2 QPSK;b = others bQAM');
% b = input('Please select the way of modulation:');
b = 2;
Ns = 128;  %num of subcarriers
Nblk = 1e4;     % num of data block
L = 4;      % L times oversampling
zdBs = [4:0.1:12];
NzdBs = length(zdBs);
SNRdBs = [0:16];
N_SNR = length(SNRdBs);

x = zeros(Nblk,Ns);
x_clipped = zeros(Nblk,Ns);
y = zeros(Nblk,Ns);
y_clipped = zeros(Nblk,Ns);


% amplitude clipping and calculate CCDF
for i = 1:N_SNR
    for k = 1:Nblk
        switch b
        case 1
            tx_data = randi([0 1],Ns,1);
            X = pskmod(tx_data,2);
        case 2
            tx_data = randi([0 3],Ns,1);
            X = pskmod(tx_data,4);
        otherwise 
            tx_data = randi([0 1],Ns,1);
            Mod = [num2str(2^b) 'QAM'];
            X = lteSymbolModulate(tx_data,Mod); 
        end
        x(k,:) = ifft(X,Ns);
        x_clipped(k,:) = signal_clipping(x(k,:),2);
        
        y(k,:) = fft(awgn(x(k,:),SNRdBs(i),'measured'));
        y_clipped(k,:) = fft(awgn(x_clipped(k,:),SNRdBs(i),'measured'));
%         pwr_signal = 10*log10(rms(x(k,:)).^2);
%         pwr_signal_clipped = 10*log10(rms(x_clipped(k,:)).^2);
%         snr_linear = 10.^(SNRdBs(i)/10);
%         pwr_noise = pwr_signal/snr_linear;   
%         pwr_noise_clipped = pwr_signal_clipped/snr_linear;
%         noise = sqrt(pwr_noise/2)*(randn(Ns, 1)+1j*randn(Ns, 1));    
%         noise_clipped= sqrt(pwr_noise_clipped/2)*(randn(Ns, 1)+1j*randn(Ns, 1));
%         y(k,:) = fft(x(k,:)+noise);
%         y_clipped(k,:) = fft(x_clipped(k,:)+noise);
        
        rx_demod = pskdemod(y(k,:),4);
        err(k) = sum(rx_demod~=tx_data');
        rx_demod = pskdemod(y_clipped(k,:),4);
        err_clipped(k) = sum(rx_demod~=tx_data');
        
        % calculate clipped signal PAPR
        N = length(x(k,:));
        xI = real(x(k,:));
        xQ = imag(x(k,:));
        Power = xI.*xI+xQ.*xQ;
        PeakP = max(Power);
        AvgP = sum(Power)/N;
        PAPRx(k) = 10*log10(PeakP/AvgP);

        % calculate original PAPR
        N = length(x_clipped(k,:));
        xI = real(x_clipped(k,:));
        xQ = imag(x_clipped(k,:));
        Power = xI.*xI+xQ.*xQ;
        PeakP = max(Power);
        AvgP = sum(Power)/N;
        PAPRx_clipped(k) = 10*log10(PeakP/AvgP);
       
    end
    ber(i) = sum(err)/Ns/Nblk;
    ber_clipped(i) = sum(err_clipped)/Ns/Nblk;
end

for i = 1:NzdBs
  CCDF_simulated(i) = sum(PAPRx>zdBs(i))/Nblk; 
  CCDF_simulated_clipped(i) = sum(PAPRx_clipped>zdBs(i))/Nblk; 
end


X_clipped_dB = 20*log10(abs(fftshift(fft(x_clipped(k,:)))));
X_dB = 20*log10(abs(fftshift(fft(x(k,:)))));
plot(X_dB-max(X_dB),'k');
figure();
plot(X_clipped_dB-max(X_clipped_dB),'k');
figure();
semilogy(zdBs,CCDF_simulated);
hold on;
semilogy(zdBs,CCDF_simulated_clipped);

figure();
semilogy(SNRdBs,ber_clipped);
hold on;
semilogy(SNRdBs,ber);

