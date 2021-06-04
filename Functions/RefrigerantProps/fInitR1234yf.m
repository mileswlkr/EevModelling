function fProps = fInitR1234yf
% Fluid initialisation R134a
    fInit.uRange = [140,450]; % [kJ/kg]
    fInit.pRange = [0.04,3.29]; % [MPa]
    fInit.mLiquid = 25;
    fInit.mVapor = 25;
    fInit.n = 60;
    fInit.substance = 'R1234yf';
    fProps = refpropLookup(fInit.uRange,fInit.pRange,fInit.mLiquid,fInit.mVapor,fInit.n,fInit.substance);
    
    fProps.Tc = 367.85; % K
end