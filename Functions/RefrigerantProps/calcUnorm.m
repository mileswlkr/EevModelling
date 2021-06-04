function unorm = calcUnorm(Pa,T,fprops)
% By defualt, refrigerant properties initialised in MATLAB with the
% twoPhaseFluidTables function create properties with respect to pressure
% and normalised internal energy (independent variables). This function is 
% used to find the normalised internal energy of test data points from 
% temperature and pressure inputs. 

% With this, the interp2 or interpn functions can be used directly to find
% all other properties (rather than each property having it's own function.

% Pa = Absolute pressure (bar)
% T = Temperature(°C)

    % Limit pressure values
    Pa = min([Pa,repmat(fprops.p_max*10,numel(Pa),1)],[],2);
    Pa = max([Pa,repmat(fprops.p_min*10,numel(Pa),1)],[],2);
    
    % Isolate liquid and vapour
    Tsat = interp1(fprops.p*10, fprops.liquid.T(end,:), Pa);
    Idl = find(T < Tsat);
    Idv = find(T >= Tsat);
    
    unorm = zeros(size(Pa));
    
    % Liquid points
    for Il = 1:numel(Idl)
        % Find the temperature vector at each pressure
        Tvect = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.T-273.15, fprops.liquid.unorm, Pa(Idl(Il)));
        % Limit values
        Tl = max([T(Idl(Il)),Tvect(1)],[],2);
        Tl = min([Tl,Tvect(end)],[],2);
        % Calculate normalised internal energy
        unorm(Idl(Il)) = interp1(Tvect, fprops.liquid.unorm, Tl);
    end
    
    % Vapour points
    for Iv = 1:numel(Idv)
        % Find the temperature vector at each pressure
        Tvect = interpn(fprops.vapor.unorm, fprops.p*10, fprops.vapor.T-273.15, fprops.vapor.unorm, Pa(Idv(Iv)));
        % Limit values
        Tl = max([T(Idv(Iv)),Tvect(1)],[],2);
        Tl = min([Tl,Tvect(end)],[],2);
        % Calculate normalised internal energy
        unorm(Idv(Iv)) = interp1(Tvect, fprops.liquid.unorm, Tl);
    end
end