% OFDM signal's PAPR simulation
% along with:
% PAPR.m(function to calculate CCDF)
% mapper.m(function to constellation mapping)

% matlab function used:
% randi([min,max],m,n)    generate m*n matrix in [min,max]
% lteSymbolModulate(in,mod)   map the bit value,in,to complex symbols
% pskmod(x,M,phaseoffset)secify the phase offset of the M-PSK constellation
clear all;close all;clc
%% CCDF of OFDM signal with 256 and 1024 subcarriers for QPSK modulation
Ns = [256 1024]; % num of subcarriers
b = 2; 
Nblk = 2e5;
zdBs = [4:0.5:12];
NzdBs = length(zdBs);
for n=1:length(Ns)
   N = Ns(n); 
   x = zeros(Nblk,N);
   sqN = sqrt(N);
   for k = 1:Nblk
      X = mapper(b,N);
      x(k,:) = ifft(X,N)*sqN;
      PAPRx(k) = PAPR(x(k,:));
   end
   for i = 1:NzdBs
      CCDF_simulated(i) = sum(PAPRx>zdBs(i))/Nblk; 
   end
   
   hold on;grid on;
   plot(zdBs,CCDF_simulated);
end
legend('256 subcarriers','1024 subcarriers');



