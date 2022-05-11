% calculate PAPR
function [PAPR_dB] = PAPR(x)
    N = length(x);
    xI = real(x);
    xQ = imag(x);
    Power = xI.*xI+xQ.*xQ;
    PeakP = max(Power);
    AvgP = sum(Power)/N;
    PAPR_dB = 10*log10(PeakP/AvgP);
end