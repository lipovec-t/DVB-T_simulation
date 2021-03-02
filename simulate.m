% Simulation of a rudimentary DVB-T system

% Author: Thomas Lipovec
% Matriculation number: 01529232
% Email: thomas.lipovec@tuwien.ac.at
% March 2021; Last revision: 02-March-2021

%% Setup
rng('default')
nSymbols = 6;      
kBits = 4; % Bits per symbol
% Generate vector of random binary data.
dataIn = randi([0 1], nSymbols*kBits, 1);

%% Modulation
dataMod = modules.qamModulation(dataIn); % 16-QAM