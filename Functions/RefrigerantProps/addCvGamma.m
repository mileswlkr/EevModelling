function fprops_out = addCvGamma(fprops,name)
% This function uses CoolProp to find all Cv values for the specified
% fluid, and adds them to the fprops structure. This allows calculation of
% the heat capacity ratio gamma.

import py.CoolProp.CoolProp.PropsSI

% Initialise:
fprops.liquid.cv = zeros(size(fprops.liquid.cp));
fprops.vapor.cv = zeros(size(fprops.vapor.cp));

% Liquid
for Ix = 1:size(fprops.liquid.cv, 1)
    for Iy = 1:size(fprops.liquid.cv, 2)
        fprops.liquid.cv(Ix,Iy) = PropsSI('CVMASS', 'H', fprops.liquid.h(Ix,Iy)*1e3, 'P', fprops.p(Iy)*1e6, name)/1e3;
    end
end
fprops.liquid.gamma = fprops.liquid.cp./fprops.liquid.cv;

% Vapour
for Ix = 1:size(fprops.vapor.cv, 1)
    for Iy = 1:size(fprops.vapor.cv, 2)
        fprops.vapor.cv(Ix,Iy) = PropsSI('CVMASS', 'H', fprops.vapor.h(Ix,Iy)*1e3, 'P', fprops.p(Iy)*1e6, name)/1e3;
    end
end
fprops.vapor.gamma = fprops.vapor.cp./fprops.vapor.cv;

% Output
fprops_out = fprops;

end