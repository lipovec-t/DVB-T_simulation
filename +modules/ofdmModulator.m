function ofdmSignal = ofdmModulator(dataModWithPilots)
% OFDM Modulator
    FFTsize = 8192;
    CPlength = 8192/4;
    ofdmSignal = zeros(nOFDMsymbols, FFTsize + CPlength);
end