function H = channelEstimation(dataRX, pilots)
% Performs channel estimation on the received data and returns the channel.
    nOFDMsymbols = 68;
    nDataCarriers = 6817;
    
    H = dataRX ./ pilots;
    H(isinf(H)|isnan(H)) = 0;
    
    for i=1:nOFDMsymbols
        H(i,:) = ifft(H(i,:), nDataCarriers);
        H(i,2048:end) = 0;
        H(i,:) = fft(H(i,:), nDataCarriers);
    end    
end