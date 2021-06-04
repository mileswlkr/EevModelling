function Tsc = calcSubcool(Pa,T,fprops)
    % Calculates the subcool temperature from pressure and temperature
    
    % Pa = absolute pressure (bar)
    % T = temperature (°C)
    % fprops = fluid properties structure
    % Tc = critical temperature (K)
    
    Pvect = [fprops.p, fprops.p_crit]*10;
    Tvect = [fprops.liquid.T(end,:), fprops.Tc]-273.15;
    P = saturate(Pa, fprops.p_min*10, fprops.p_crit*10);
    Tsat = interp1(Pvect, Tvect, P);
    Tsc = Tsat - T;
end
    