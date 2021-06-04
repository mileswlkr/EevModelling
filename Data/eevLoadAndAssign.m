% Script for loading and assigning data for EEV modelling

% Load data and initialise fluid properties
    loadConcatData
    unorm1 = load('unorm_2021-01-28_07-54-16.mat');
    unorm2 = load('unorm_2021-01-29_07-24-54.mat');
    fprops = fInitR1234yf;

% Assign data & look up properties 
    Dpipe = inch2mm(1/2)/1e3; % m. Pipe diameter based on EEV connection diameter.
    Dmax = 1.8e-3; % m. Valve orifice diameter
    Amax = pi*Dmax^2/4; % m^2. Maximum opening area
    time = TD.Date_Time;
    mdot = TD.mdotr/60^2; % kg/s
    Pup = gauge2abs(interpNaN(TD.P3_mfOut)); % 2 NaN values in upstream pressure. Also convert from gauge to absolute pressure
    Pdown = gauge2abs(TD.P4_exvOut); % Convert from gauge to absolute 
    Tup = TD.T3_mfOut;
    Tdown = TD.T4_exvOut;
    lift = saturate(TD.exv, 0, 100)/100;
    Tc = 367.85; % K. Critical temperature (not available through fprops)
    Pc = fprops.p_crit*10; % bar. Critical pressure.
    
    % Normalised specific internal energy (phase assumed):
    unormup = [unorm1.unormPh.un3_mfOut; unorm2.unormPh.un3_mfOut];
    unormdown = [unorm1.unormPh.un4_exvOut; unorm2.unormPh.un4_exvOut];
    unormdownth = [unorm1.unorm_th.un4_exvOut; unorm2.unorm_th.un4_exvOut];

% Calculated refrigerant properties
    % Subcool:
    Tscup = calcSubcool(Pup,Tup,fprops);
    Tscdown = calcSubcool(Pdown,Tdown,fprops);
    
    % Enthalpy:
    hup = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.h, unormup, ...
                  saturate(Pup, fprops.p_min*10, fprops.p_max*10)); % kJ/kg
    
    % Kinematic viscosity:
    nu_up = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.nu, unormup, ...
                    saturate(Pup, fprops.p_min*10, fprops.p_max*10))/1e6; % m^2/s
    nu_down = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.nu, unormdown, ...
                    saturate(Pdown, fprops.p_min*10, fprops.p_max*10))/1e6; % m^2/s
    
    % Densities:
    rhoup = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.rho, ...
                    saturate(unormup,-1,0), ...
                    saturate(Pup, fprops.p_min*10, fprops.p_max*10));
    rhodown = interpn(fprops.liquid.unorm, fprops.p*10, fprops.liquid.rho, unormdown, ...
                    saturate(Pdown, fprops.p_min*10, fprops.p_max*10));
    
    % Reynolds number:
    Re_up = 4/pi/Dpipe* mdot./(nu_up.*rhoup);
    Re_down = 4/pi/Dpipe* mdot./(nu_down.*rhodown);
    
    % Theoretical downstream normalised speific internal energy:
    hdown_th = hup;
    
    % Saturated pressure and temperature:
    Psat = interp1(fprops.liquid.h(end,:), fprops.p*10, hup);
    Tsat = interp1(fprops.p*10, fprops.liquid.T(end,:), saturate(Pup, fprops.p_min*10, fprops.p_max*10));
    Psat_T = interp1(fprops.liquid.T(end,:)-273.15, fprops.p*10, min([Tup, Tsat],[],2));
    
    % Density of saturated liquid at saturation pressure:
    rho_f = interp1(fprops.p*10, fprops.liquid.rho(end,:), Psat);
    
% Signal filtering/correction:
    % Maximum rate of change:
    lift_crrctd = ratelim(0:numel(time), lift, -0.03, 0.03);

    % Delay:
    mdot_crrctd = delayRemove(mdot,4); % 4 second delay was observed to give best match between models and data during transients
    Re_up_crrctd = 4/pi/Dpipe* mdot_crrctd./(nu_up.*rhoup);
    Re_down_crrctd = 4/pi/Dpipe* mdot_crrctd./(nu_down.*rhodown);