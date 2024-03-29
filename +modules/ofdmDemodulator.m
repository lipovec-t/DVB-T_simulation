function dataRX = ofdmDemodulator(ofdmSignalRXsynchronized)
% OFDM Demodulator
    nOFDMsymbols = 68;
    FFTsize = 8192;
    CPlength = 8192/4;
    dataRX = zeros(nOFDMsymbols, FFTsize);
    
    for i=1:nOFDMsymbols
        % Remove CP
        dataRX(i,:) = ofdmSignalRXsynchronized(i,CPlength+1:end);
        % FFT
        dataRX(i,:) = fft(dataRX(i,:), FFTsize);
        % zero frequency shift
        %dataRX(i,:) = fftshift(dataRX(i,:));
    end
end