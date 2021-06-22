function h = channelGenerator(d1, d2, d3)
% Generate Ricean fading channel (channel impulse response)
% Input: Tx - RX distances
    
    % Amplitudes
    A1 = 1 / d1;
    A2 = 1 / d2;
    A3 = 1 / d3;

    % propagation delays 
    l1 = 3*d1 / 100;
    l2 = 3*d2 / 100;
    l3 = 3*d3 / 100;

    % decay factors for PDP
    decay1 = 1.2;
    decay2 = 1.7;
    decay3 = 3.1;

    % Number of multipaths
    nMultipaths1 = 40;
    nMultipaths2 = 33;
    nMultipaths3 = 72;

    % taps per Tx - RX
    tau1 = 0:nMultipaths1;
    tau2 = 0:nMultipaths2;
    tau3 = 0:nMultipaths3;

    % Power Delay Profiles (PDP)
    PDP1    = exp(-decay1 * tau1);
    PDPamp1 = sqrt(PDP1);
    PDP2    = exp(-decay2 * tau2);
    PDPamp2 = sqrt(PDP2);
    PDP3    = exp(-decay3 * tau3);
    PDPamp3 = sqrt(PDP3);
    
    % Ricean fading
    
