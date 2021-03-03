% Simulation of a rudimentary DVB-T system

% Author: Thomas Lipovec
% Matriculation number: 01529232
% Email: thomas.lipovec@tuwien.ac.at
% March 2021; Last revision: 02-March-2021

%% Generate Data
rng('default')
nSamples = 6817;
kBits = 4; % Bits per sample
nOFDMsymbols = 68; % per frame
% Generate vector of random binary data.
dataIn = randi([0 1], 68, nSamples*kBits);

%% Modulation
dataMod = zeros(nOFDMsymbols, nSamples);
for i=1:nOFDMsymbols
    dataMod(i,:) = modules.qamModulation(dataIn(i,:)); % 16-QAM
end

%% Pilot insertion
dataModWithPilots = modules.pilotInsertion(dataMod);

%% OFDM modulator
ofdmSignal = modules.ofdmModulator(dataModWithPilots);
