function H = channelEstimation(dataRX, pilots)
% Performs channel estimation on the received data and returns the channel.
    nOFDMsymbols = 68;
    nSubcarriers = 6817;
    H = zeros(nOFDMsymbols, nSubcarriers);
    H = dataRX ./ pilots;
    H(isinf(H)|isnan(H)) = 0;
        
end