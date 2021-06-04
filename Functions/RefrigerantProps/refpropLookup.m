function Ref = refpropLookup(uRange,pRange,mLiquid,mVapor,n,substance)

    installPath = 'C:\Program Files (x86)\REFPROP';

    Ref = twoPhaseFluidTables(uRange,pRange,mLiquid,mVapor,n,substance,installPath);

    %%% Create additional fields
    % Specific enthalpy [kJ/kg]
    Ref.liquid.h = Ref.liquid.u + repmat(Ref.p,mLiquid,1).*Ref.liquid.v*10^3; % Element wise multiplication of pv
    Ref.vapor.h = Ref.vapor.u + repmat(Ref.p,mVapor,1).*Ref.vapor.v*10^3; % Element wise multiplication of pv
    % Densities [kg/m^3]
    Ref.liquid.rho = 1./Ref.liquid.v;
    Ref.vapor.rho = 1./Ref.vapor.v;
    % Specific heat capacity [kJ/kg/K]
    [~, Ref.vapor.dhg_dunorm] = gradient(Ref.vapor.h*10^3, Ref.p*10^6, Ref.vapor.unorm);
    [~, Ref.vapor.dT_dunorm] = gradient(Ref.vapor.T, Ref.p*10^6, Ref.vapor.unorm);
    dhg_dT = Ref.vapor.dhg_dunorm./Ref.vapor.dT_dunorm;
    Ref.vapor.cp = dhg_dT/1e3;
    [~, dhg_dunorm] = gradient(Ref.liquid.h*10^3, Ref.p*10^6, Ref.liquid.unorm);
    [~, dT_dunorm] = gradient(Ref.liquid.T, Ref.p*10^6, Ref.liquid.unorm);
    dhg_dT = dhg_dunorm./dT_dunorm;
    Ref.liquid.cp = dhg_dT/1e3;
    % Latent heat of vapourisation [kJ/kg]
    Ref.hfg = Ref.vapor.h(1,:) - Ref.liquid.h(end,:);
    % Rate of change of saturated vapour specific enthalpy with pressure [J/kg/Pa]
    Ref.vapor.dhg_dP = gradient(Ref.vapor.h(1,:)*10^3,Ref.p*10^6);
    % Rate of change of saturated liquid density with pressure [kg/m^3/Pa]
    Ref.liquid.drhol_dP = gradient(Ref.liquid.rho(end,:),Ref.p*10^6);
    % Rate of change of latent heat of vaourisation with pressure [J/kg/Pa]
    Ref.dhfg_dP = gradient(Ref.hfg(1,:)*10^3,Ref.p*10^6);

    %%% Fluid properties acquired
    % unorm = Normalised specific internal energy (-1 to 0, 1 to 2 depending on liquid or vapour. Such that 0-1 is left for 2-phase region)
    % v = Specific volume [m^3/kg]
    % s = Specific entropy [kJ/(kg*K)]
    % T = Temperature [K]
    % nu = Kinematic viscosity [mm^2/s]
    % k = Thermal conductivity [W/(m*K)]
    % Pr = Prandtl number
    % u_sat = Saturation specific internal energy [kJ/kg]
    % u = Specific internal energy [kJ/kg]

    %%% Fluid properties created
    % h = Specific enthalpy [kJ/kg]
    % rho = Density [kg/m^3]
    
    %%% Input specification
    % Input 1: uRange - Lower and upper bounds of the specific internal energy range onto which to map the fluid properties [kJ/kg]
    % Input 2: pRange - Lower and upper bounds of the (absolute) pressure range onto which to map the fluid properties [MPa]
    % Input 3: mLiquid - Number of rows to include in the fluid tables for the liquid phase
                       % Each row gives the fluid properties at a fixed value of the normalized specific internal energy
    % Input 4: mVapor - Number of rows to include in the fluid tables for the vapour phase
    % Input 5: n - Number of columns to include in the fluid tables
    % Input 6: substance - Name of the fluid whose property tables the function is to construct (must be same as REFPROP)

end