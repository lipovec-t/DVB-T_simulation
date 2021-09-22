function H = channelEstimation(dataRX, pilots)
% Performs channel estimation on the received data and returns the channel.

    % estimate channel on pilot positions
    H = dataRX ./ pilots;
    H(isinf(H)|isnan(H)) = NaN + 1i*NaN;
    
    % 1D interpolation over subcarriers
    H = fillmissing(H, 'spline', 2);
    
end