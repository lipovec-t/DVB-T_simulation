function [errorCount, errorRatio] = simulateFrameNoChannel()
% Simulation of a frame consisting of 68 OFDM symbols without any channel.

    %% Generate Data
    nSamples = 6817;
    kBits = 4; % Bits per sample
    nOFDMsymbols = 68; % per frame
    % Generate vector of random binary data.
    dataIn = randi([0 1], 68, nSamples*kBits);

    %% 16-QAM
    dataMod = zeros(nOFDMsymbols, nSamples);
    for i=1:nOFDMsymbols
        dataMod(i,:) = modules.qamModulation(dataIn(i,:)); 
    end

    %% Pilot insertion
    [dataModWithPilots, ~, pilotPositions] = modules.pilotInsertion(dataMod);

    %% OFDM modulator
    ofdmSignalTX = modules.ofdmModulator(dataModWithPilots);

    %% Demodulation
    ofdmSignalRX = modules.ofdmDemodulator(ofdmSignalTX);
    % extract data of used subcarriers
    ofdmSignalRX = ofdmSignalRX(:,1:6817);

    %% Demapping
    dataDemapped = modules.symbolDemapping(ofdmSignalRX);
    % Remove pilots and get serial stream of data
    dataDemapped = dataDemapped.';
    dataDemapped(logical(pilotPositions.')) = [];
    dataOut = de2bi(dataDemapped, 'left-msb');

    %% Compute number of bit errors
    % Get original data stream
    dataCompare = modules.symbolDemapping(dataMod);
    dataCompare = dataCompare.';
    dataCompare(logical(pilotPositions.')) = [];
    dataCompare = de2bi(dataCompare.', 'left-msb');

    % Compute errors
    errorCount = sum(reshape(dataOut',1,[]) ~= reshape(dataCompare',1,[]));
    errorRatio = errorCount / numel(dataOut);
    
end