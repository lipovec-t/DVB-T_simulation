function ofdmSignal = ofdmModulator(dataModWithPilots)
% OFDM Modulator
    nOFDMsymbols = 68;
    FFTsize = 8192;
    CPlength = 8192/4;
    ofdmSignal = zeros(nOFDMsymbols, FFTsize + CPlength);
    for i=1:nOFDMsymbols
        ofdmSignal(i,CPlength+1:end) = ifft(dataModWithPilots(i,:), FFTsize);
        ofdmSignal(i,1:CPlength) = ofdmSignal(i, end-CPlength+1:end);
    end
        
end