function H = channelEstimation(dataRX, pilots)
% Performs channel estimation on the received data and returns the channel.
    nOFDMsymbols = 68;
    nDataCarriers = 6817;
    
    H = dataRX ./ pilots;
    H(isinf(H)|isnan(H)) = NaN + 1i*NaN;
    
    % 1D interpolation
    %interpolate over freqeuncy
    H = fillmissing(H,'spline',2);
end