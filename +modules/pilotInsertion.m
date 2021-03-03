function dataWithPilots = pilotInsertion(dataMod)
% Inserts pilots in the 68x6817 frame grid.
    nOFDMsymbols = 68;
    nSubcarriers = 6817;
    PRBS = comm.PNSequence('VariableSizeOutput', true, 'MaximumOutputSize', [nSubcarriers 1]);
    PRBS.Polynomial = 'z^11 + z^2 + 1';
    PRBS.InitialConditions = [1 1 1 1 1 1 1 1 1 1 1];
    sequence = PRBS(nSubcarriers);
    pilotPositions = zeros(nOFDMsymbols, nSubcarriers);
    pilots = zeros(nOFDMsymbols, nSubcarriers);
    for i=1:nOFDMsymbols
        for j=(mod(i-1,4)*3+3+1):12:nSubcarriers
            pilotPositions(i,j) = 1;
            pilots(i,j) = 4/3 * 2 * (1/2 - sequence(j));
        end
    end
    dataPositions = ones(nOFDMsymbols, nSubcarriers)-pilotPositions;
    dataWithPilots = dataMod .* dataPositions + pilots;
end