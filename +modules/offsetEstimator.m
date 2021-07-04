function ofdmSignalRXsynchronized = offsetEstimator(ofdmSignalRX, SNR, timeOffset, frequencyOffset)
% Estimates the time and frequency offset of an received OFDM signal
% naming of the function according to the lecture notes
    K = 8192;
    CPlength = 2048;    
    dataLength = length(ofdmSignalRX);
    
    phi = zeros(1,dataLength-K-CPlength-1);
    for i = 1:length(phi)
        phi(i) = sum(ofdmSignalRX(i:i+2048-1) .* conj(ofdmSignalRX(i+K:i+K+2048-1)));
    end
    
    psi = zeros(1,dataLength-K-CPlength-1);
    for i = 1:length(phi)
        psi(i) = 1/2 * sum( abs(ofdmSignalRX(i:i+2048-1)).^2 + abs(ofdmSignalRX(i+K:i+K+2048-1)).^2 );
    end
    
    gamma = abs(phi) - 1/(1+SNR) * psi;
    
    % plot
    xrange = 1:length(gamma);
    [timeOffsets,timeOffsetsLocs] = findpeaks(gamma, 'MinPeakDistance', 9000);
    figure()
    plot(xrange,gamma,xrange(timeOffsetsLocs),timeOffsets,'or')
    
    % compute frequency offset
    maxGamma = max(gamma);
    offset = find(gamma == maxGamma);
    frequencyOffsetEstimate = -angle(phi(offset)) / (2*pi);
    
    % remove frequency offset
    m = 0:1:length(ofdmSignalRX)-1;
    ofdmSignalRXremovedFrequOffset = ofdmSignalRX .* exp(-1i*2*pi*frequencyOffsetEstimate*m/8192);
    
    % extract OFDM symbols - 1 frame = 68 symbols of length 10240
    ofdmSignalRXsynchronized = zeros(68,10240);
    for i=1:68
        ofdmSignalRXsynchronized(i,:) = ofdmSignalRXremovedFrequOffset(timeOffsetsLocs(i):timeOffsetsLocs(i)+10240-1);
    end
    
end