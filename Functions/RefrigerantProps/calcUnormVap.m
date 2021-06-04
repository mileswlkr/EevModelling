function unorm = calcUnormVap(Pa,T,fprops)
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
    
    unorm = zeros(size(Pa));
    
    for Ix = 1:numel(Pa)
        % Find the temperature vector at each pressure
        Tvect = interpn(fprops.vapor.unorm, fprops.p*10, fprops.vapor.T-273.15, fprops.vapor.unorm, Pa(Ix));
        % Limit values
        Tl = max([T(Ix),Tvect(1)],[],2);
        Tl = min([Tl,Tvect(end)],[],2);
        % Calculate normalised internal energy
        unorm(Ix) = interp1(Tvect, fprops.vapor.unorm, Tl);
    end

end