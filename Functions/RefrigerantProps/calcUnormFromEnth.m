function unorm = calcUnormFromEnth(Pa,h,fprops)
% This function was designed to be used to find the theoretical normalised
% specific energy downstream of the expansion valve.
    
    % Limit pressure values
    Pa = min([Pa,repmat(fprops.p_max*10,numel(Pa),1)],[],2);
    Pa = max([Pa,repmat(fprops.p_min*10,numel(Pa),1)],[],2);
    
    % Isolate liquid and vapour
    hl = interp1(fprops.p*10, fprops.liquid.h(end,:), Pa);
    hv = interp1(fprops.p*10, fprops.vapor.h(1,:), Pa);
    Idl = find(h < hl);
    Idv = find(h > hv);
    Id2ph = find(h >= hl & h <= hv);
    
    unorm = zeros(size(Pa));
    
    % Liquid points
    for Il = 1:numel(Idl)
        % Find the enthalpy vector at each pressure
        hvect = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.h, fprops.liquid.unorm, Pa(Idl(Il)));
        % Calculate normalised internal energy
        unorm(Idl(Il)) = interp1(hvect, fprops.liquid.unorm, h(Idl(Il)));
    end
    
    % Vapour points
    for Iv = 1:numel(Idv)
        % Find the enthalpy vector at each pressure
        hvect = interpn(fprops.vapor.unorm, fprops.p*10, fprops.vapor.h, fprops.vapor.unorm, Pa(Idv(Iv)));
        % Calculate normalised internal energy
        unorm(Idv(Iv)) = interp1(hvect, fprops.liquid.unorm, h(Idl(Il)));
    end
    
    % Two-phase points
    unorm(Id2ph) = (h(Id2ph) - hl(Id2ph))./(hv(Id2ph) - hl(Id2ph)); % Standard quality calculation
    
end