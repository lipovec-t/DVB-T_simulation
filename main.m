% Simulation of a rudimentary DVB-T system

% Author: Thomas Lipovec
% Matriculation number: 01529232
% Email: thomas.lipovec@tuwien.ac.at
% Dec 2020; Last revision: 30-Dec-2020

%% Setup
rng('default')
nSymbols = 6;      
kBits = 4; % Bits per symbol
% Generate vector of random binary data.
dataIn = randi([0 1], nSymbols*kBits, 1);

%% Modulation
dataMod = qamModulation(dataIn); % 16-QAM