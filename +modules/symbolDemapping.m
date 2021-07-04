function dataDemappedEstimated = symbolDemapping(dataRXestimated)
% 16-QAM using Gray modulation mapping.

    M = 16;         % Constellation size
       
    % Constellation order: from upper left to lower right columnwise.
    smap = [8,9,13,12,10,11,15,14,2,3,7,6,0,1,5,4];
    
    % QAM - requires the communication toolbox
    dataDemappedEstimated = zeros(size(dataRXestimated));
    for i=1:68      
        dataDemappedEstimated(i,:) = qamdemod(dataRXestimated(i,:),M,smap,...
                     'PlotConstellation',false,'UnitAveragePower',true); 
    end
end