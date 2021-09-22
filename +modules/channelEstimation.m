function H = channelEstimation(dataRX, pilots)
% Performs channel estimation on the received data and returns the channel.
    nOFDMsymbols = 68;
    nDataCarriers = 6817;
    
    H = dataRX ./ pilots;
    H(isinf(H)|isnan(H)) = NaN + 1i*NaN;
    
    %interpolate over freqeuncy
    H = fillmissing(H,'spline',2);
    %interpolate over time
    %H = fillmissing(H,'spline');
    
    
%     H=H(H~=0);
%     
%     for i=1:nOFDMsymbols
%         H(i,:) = ifft(H(i,:), nDataCarriers);
%         H(i,2048:end) = 0;
%         H(i,:) = fft(H(i,:), nDataCarriers);
%     end
    
%     for i=1:nOFDMsymbols
%         queryPoints = find(H(i,:)==0);
%         y = spline(find(H(i,:)),H(i,find(H(i,:))),queryPoints);
%         H(i,queryPoints) = y;
%     end
    
%     [gr, gc, gv] = find(H);
%     F = scatteredInterpolant(gr, gc, gv);
%     [br, bc] = find(H==0);
%     replacements = F(br, bc);
%     H( sub2ind(size(H), br, bc) ) = replacements;
end