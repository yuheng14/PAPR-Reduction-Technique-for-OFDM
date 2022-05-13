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
SNRdBs = [0:12];
N_SNR = length(SNRdBs);

x = zeros(Nblk,Ns*L);
x_clipped = zeros(Nblk,Ns);

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
