function H = channelEstimation(dataRX, pilots)
% Performs channel estimation on the received data and returns the channel.
    nOFDMsymbols = 68;
    nSubcarriers = 6817;
    H = zeros(nOFDMsymbols, nSubcarriers);
    H = dataRX ./ pilots;
    H(isinf(H)|isnan(H)) = 0;
    
    interpolatedH = @(y,x) interp2(1:nSubcarriers,1:nOFDMsymbols,H,x,y);
    %interpolatedH = @(y,x) griddata(1:nSubcarriers,1:nOFDMsymbols,H,x,y); 
    for i=1:nOFDMsymbols
        for j =1:nSubcarriers
            if H == 0
                H(i,j) = interpolatedH(i,j);
            end
        end
    end    
end