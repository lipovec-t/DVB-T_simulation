% Simulation of a rudimentary DVB-T system
% based on ETSI EN 300 744 V1.6.1 (2009-01)

% Author: Thomas Lipovec
% Matriculation number: 01529232
% Email: thomas.lipovec@tuwien.ac.at
% Last revision: 22-September-2021

% DVB-T Parameters:
%   FFT Size                    = 8192
%   Number of used subcarriers  = 6817
%   Number of data carriers     = 6247
%   Number of pilots            = 570
%   Relative CP length          = 1/4
%   Constellation               = 16-QAM

% 1 OFDM Symbol     = 8192 + 8192/4     = 10240 samples
% 1 frame           = 68 OFDM symbols   = 696320 samples


%% Main simulation loop
% SNR values to evaluate
SNRdB = 0:40;
% allocate vector for BER values and estimation errors
BER = zeros(1,numel(SNRdB));
timeOffsetEstMSE = zeros(1,numel(SNRdB));
frequencyOffsetEstMSE = zeros(1,numel(SNRdB));
channelEstMSE = zeros(1,numel(SNRdB));
% transmitted data bits in 1 frame
nDataBits = 1699252;

for j = 1:numel(SNRdB)   
    % repeat until at least 10 errors have been observed
    i = 1;
    errorCount = 0;
    while errorCount < 10
        [iErrorCount, ~,  timeErr, frequencyErr, channelErr] = simulateFrame(SNRdB(j));
        errorCount = errorCount + iErrorCount;
        BER(j) =  errorCount / (i*nDataBits);
        timeOffsetEstMSE(j) = timeOffsetEstMSE(j) + timeErr;
        frequencyOffsetEstMSE(j) = frequencyOffsetEstMSE(j) + frequencyErr;
        channelEstMSE(j) = channelEstMSE(j) + channelErr;
        i=i+1;
    end
    timeOffsetEstMSE(j) = timeOffsetEstMSE(j) / (i-1);
    frequencyOffsetEstMSE(j) = frequencyOffsetEstMSE(j) / (i-1);
    channelEstMSE(j) = channelEstMSE(j) / (i-1);
end

figure();
semilogy(SNRdB, BER);
xlabel('SNR (dB)')
ylabel('BER')

figure()
semilogy(SNRdB, timeOffsetEstMSE);
xlabel('SNR (dB)')
ylabel('Timeoffset Estimation MSE')

figure()
semilogy(SNRdB, frequencyOffsetEstMSE);
xlabel('SNR (dB)')
ylabel('Frequency Estimation MSE')
 
figure()
semilogy(SNRdB, channelEstMSE);
xlabel('SNR (dB)')
ylabel('Channel Estimation MSE')




