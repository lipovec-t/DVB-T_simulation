% Simulation of a rudimentary DVB-T system

% Author: Thomas Lipovec
% Matriculation number: 01529232
% Email: thomas.lipovec@tuwien.ac.at
% March 2021; Last revision: 07-July-2021

% DVB-T Parameters:
%   FFT Size                    = 8192
%   Number of used subcarriers  = 6817
%   Number of data carriers     = 6247
%   Number of pilots            = 570
%   Relative CP length          = 1/4
%   Constellation               = 16-QAM

% 1 OFDM Symbol     = 8192 + 8192/4     = 10240 samples
% 1 frame           = 68 OFDM symbols   = 696320 samples


%% Generate Data
%rng('default')
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
[dataModWithPilots, pilots, pilotPositions] = modules.pilotInsertion(dataMod);

%% OFDM modulator
ofdmSignalTX = modules.ofdmModulator(dataModWithPilots);

%% Channel simulation
SNRdB   = 20;
SNRlin  = 10^(SNRdB/10);
% transmit data over channel
channelLength = length(modules.channelGenerator); % 1370
channel = zeros(68,channelLength);
% ofdmSignalRX1 corresponds to a received frame of OFDM symbols
ofdmSignalRX1 = zeros(68, 10240);% + channelLength - 1);

for i=1:nOFDMsymbols
    signalTX = ofdmSignalTX(i,:);
    signalPower = sum(abs(signalTX).^2) / length(signalTX);
    noisePower = signalPower / SNRlin;
    % convolution with channel impulse response
    channel(i,:) = modules.channelGenerator();
    RXdataNoNoise = conv(signalTX,channel(i,:));
    %RXdataNoNoise = tools.convolve(channel(i,:), signalTX).';
    n = sqrt(noisePower/2) * (randn(1,length(RXdataNoNoise)) + 1j*randn(1,length(RXdataNoNoise)));
    RXdata1 = RXdataNoNoise + n;
    ofdmSignalRX1(i,:) = RXdata1(1:10240);
end

% reshape received OFDM frame to a row vector
ofdmSignalRX2 = reshape(ofdmSignalRX1',1,[]);

% time and frequency offset
timeOffset = randi([0,600],1);
frequencyOffsetMin = -1/2;
frequencyOffsetMax = 1/2;
frequencyOffset = (frequencyOffsetMax - frequencyOffsetMin) * rand() + frequencyOffsetMin;
ofdmSignalRXdelayed = [zeros(1,timeOffset), ofdmSignalRX2];
ofdmSignalRXdelayed(1:timeOffset) = sqrt(noisePower/2) * (randn(1,timeOffset) + 1j*randn(1,timeOffset));
m = 0:1:length(ofdmSignalRXdelayed)-1;
ofdmSignalRX = ofdmSignalRXdelayed .* exp(1i*2*pi*frequencyOffset*m/8192);

%% Synchronisation
%ofdmSignalRXsynchronized = modules.offsetEstimatorNew(ofdmSignalRX, SNRlin, timeOffset, frequencyOffset);
ofdmSignalRXsynchronized = ofdmSignalRX1; % without offset & synchronization

%% Demodulation
dataRX = modules.ofdmDemodulator(ofdmSignalRXsynchronized);
% extract data of used subcarriers
dataRXestimated = dataRX(:,1:6817);

%% Channel Estimation
Hest = modules.channelEstimation(dataRXestimated, pilots);

% assume perfect channel knowledge
H = zeros(nOFDMsymbols,8192);
for i=1:nOFDMsymbols
    H(i,:) = fft(channel(i,:),8192);
end
H = H(:,1:6817);
%----------------------------------
dataRXestimated = dataRXestimated ./ H;

%% Demapping
dataDemappedEstimated = modules.symbolDemapping(dataRXestimated);
% Remove pilots and get serial stream of data
dataDemappedEstimated = dataDemappedEstimated.';
dataDemappedEstimated(logical(pilotPositions.')) = [];
dataOut = de2bi(dataDemappedEstimated, 'left-msb');

%% Compute number of bit errors
% Get original data stream
dataCompare = modules.symbolDemapping(dataMod);
dataCompare = dataCompare.';
dataCompare(logical(pilotPositions.')) = [];
dataCompare = de2bi(dataCompare.', 'left-msb');


% Compute errors
errorCount = sum(reshape(dataOut',1,[]) ~= reshape(dataCompare',1,[]));
errorRatio = errorCount / numel(dataOut);



