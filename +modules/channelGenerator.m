function h = channelGenerator()
% Generate Ricean fading channel (channel impulse response)

    % TX - RX distances
    d1 = 2000;
    d2 = 10000;
    d3 = 40000;

    % Amplitudes
    A1 = 1 / d1;
    A2 = 1 / d2;
    A3 = 1 / d3;

    % propagation delays 
    l1 = 3*d1 / 100; % = 60
    l2 = 3*d2 / 100; % = 300
    l3 = 3*d3 / 100; % = 600

    % decay factors for PDP
    decay1 = 0.2;
    decay2 = 0.13;
    decay3 = 0.4;

    % Number of multipaths
    nMultipaths1 = 132;
    nMultipaths2 = 314;
    nMultipaths3 = 169;

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
    
    % Ricean fading - generated from two Gaussian according to Wikipedia
    K = 2;
    s = sqrt(K/(1+K));
    sigma = sqrt(1/(2*(1+K)));
    
    X1 = s + sigma * randn(1,nMultipaths1+1);
    Y1 = sigma * randn(1,nMultipaths1+1);
    riceanAmp1 = X1 + 1j*Y1;
    
    X2 = s + sigma * randn(1,nMultipaths2+1);
    Y2 = sigma * randn(1,nMultipaths2+1);
    riceanAmp2 = X2 + 1j*Y2;
    
    X3 = s + sigma * randn(1,nMultipaths3+1);
    Y3 = sigma * randn(1,nMultipaths3+1);
    riceanAmp3 = X3 + 1j*Y3;
    
    % impulse response
    h1 = riceanAmp1.*PDPamp1;    
    h2 = riceanAmp2.*PDPamp2; 
    h3 = riceanAmp3.*PDPamp3;
    
    h_notNormalized = zeros(1,l3+nMultipaths3+1);
    h_notNormalized(l1:l1+nMultipaths1) = h_notNormalized(l1:l1+nMultipaths1) + h1;
    h_notNormalized(l2:l2+nMultipaths2) = h_notNormalized(l2:l2+nMultipaths2) + h2;
    h_notNormalized(l3:l3+nMultipaths3) = h_notNormalized(l3:l3+nMultipaths3) + h3;
        
    h = h_notNormalized / sqrt(sum(abs(h_notNormalized).^2));
    
    
    
