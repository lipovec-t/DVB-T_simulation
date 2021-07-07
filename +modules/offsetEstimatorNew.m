function ofdmSignalRXsynchronized = offsetEstimatorNew(ofdmSignalRX, SNR, timeOffset, frequencyOffset)
% Estimates the time and frequency offset of an received OFDM signal
% naming of the function according to the lecture notes
    K = 8192;
    CPlength = 2048;
    oberservationWindow = 2 * K + CPlength;
    dataLength = length(ofdmSignalRX(1:oberservationWindow));
    perfectLength = 68*10240;
    
    phi = zeros(1,dataLength-K-CPlength-1);
    for i = 1:length(phi)
        phi(i) = sum(ofdmSignalRX(i:i+CPlength-1) .* conj(ofdmSignalRX(i+K:i+K+CPlength-1)));
    end
    
    psi = zeros(1,dataLength-K-CPlength-1);
    for i = 1:length(phi)
        psi(i) = 1/2 * sum( abs(ofdmSignalRX(i:i+CPlength-1)).^2 + abs(ofdmSignalRX(i+K:i+K+CPlength-1)).^2 );
    end
    
    gamma = abs(phi) - 1/(1+SNR) * psi;
    
    % compute frequency offset
    maxGamma = max(gamma);
    offset = find(gamma == maxGamma);
    % offset = timeOffset;
    frequencyOffsetEstimate = -angle(phi(offset)) / (2*pi);
    
    % remove frequency offset
    m = 0:1:length(ofdmSignalRX)-1;
    ofdmSignalRXremovedFrequOffset = ofdmSignalRX .* exp(-1i*2*pi*frequencyOffsetEstimate*m/8192);
    
    % remove timing offset
    ofdmSignalRXsynchronized = ofdmSignalRXremovedFrequOffset(offset+1:end);
    if perfectLength-length(ofdmSignalRXsynchronized) >= 0
        ofdmSignalRXsynchronized = [ofdmSignalRXsynchronized, zeros(1,perfectLength-length(ofdmSignalRXsynchronized))];
    else
        ofdmSignalRXsynchronized = ofdmSignalRXsynchronized(1:perfectLength);
    end
    ofdmSignalRXsynchronized = reshape(ofdmSignalRXsynchronized,10240,68)';
end