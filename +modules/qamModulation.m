function dataMod = qamModulation(dataIn)
% 16-QAM using Gray modulation mapping.

    M = 16;         % Constellation size
    k = log2(M);    % Bits per symbol = 4
    N = length(dataIn)/k;  % Number of symbols
    
    dataInMatrix = reshape(dataIn, k, N).'; % N x k matrix
    dataSymbolsIn = bi2de(dataInMatrix, 'left-msb'); % N x 1 vector
    
    % Constellation order: from upper left to lower right columnwise.
    smap = [8,9,13,12,10,11,15,14,2,3,7,6,0,1,5,4];
    % QAM - requires the communication toolbox.
    dataMod = qammod(dataSymbolsIn,M,smap,...
                     'PlotConstellation',false,'UnitAveragePower',true); 
end