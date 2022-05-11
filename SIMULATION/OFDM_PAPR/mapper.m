% MPSK/QAM modulation
function [tx_symbol,Mod] = mapper(b,N)
    if b == 1
        tx_data = randi([0 1],N,1);
        Mod ='BPSK';
        tx_symbol = pskmod(tx_data,2);
    elseif b == 2
        tx_data = randi([0 3],N,1);
        Mod = 'QPSK';
        tx_symbol = pskmod(tx_data,4);
    else
        Mod = [num2str(2^b) 'QAM'];
        tx_symbol = lteSymbolModulate(tx_data,Mod); 
    end
end
