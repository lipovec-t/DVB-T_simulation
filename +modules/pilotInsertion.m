function dataWithPilots = pilotInsertion(dataMod)
pnSequence = comm.PNSequence('VariableSizeOutput', true, 'MaximumOutputSize', [6817 1]);
pnSequence.Polynomial = 'z^11 + z^2 + 1';
pnSequence.InitialConditions = [1 1 1 1 1 1 1 1 1 1 1];
test = pnSequence(6817);
    
end