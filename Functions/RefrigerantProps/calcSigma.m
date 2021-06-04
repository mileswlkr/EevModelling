function sigma = calcSigma(Pbar, fprops, ref)
% Function for calculating surface tension in the two-phase region.
% The surface tension units are N/m.

% Quicker to define an array from CoolProp then reference this for
% interpolation if the input pressure array is > 50 elements.
import py.CoolProp.CoolProp.PropsSI
np = numel(Pbar);
sigma = zeros(1,np);

Pmin = fprops.p_min*1e6;
Pmax = fprops.p_max*1e6;

if np > 50
    % Create vector 
    Pvect = linspace(Pmin, Pmax, 50);
    for Ix = 1:50
        sigmaVect(Ix) = PropsSI('I','P',Pvect(Ix),'Q',0.5,ref);
    end
    sigma = interp1(Pvect, sigmaVect, saturate(Pbar*1e5, Pmin, Pmax));
else
    for Ip = 1:np
        sigma(Ip) = PropsSI('I','P',saturate(Pbar(Ip)*1e5, Pmin, Pmax),'Q',0.5,ref);
    end
end