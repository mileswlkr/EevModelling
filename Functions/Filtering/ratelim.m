function out = ratelim(time,data,lo,up)
% This function limits the rate of change of a signal using a time signal
% (in seconds), lower (lo) and upper(up) rate limits (1/s)

% Initialise
out = zeros(size(data));
out(1) = data(1);

% Work through data imposing rate limits where required.
for Ix = 2:numel(data)
    dy_dx = (data(Ix) - out(Ix-1))/(time(Ix) - time(Ix-1));
    if dy_dx > up
        out(Ix) = out(Ix-1) + up*(time(Ix) - time(Ix-1));
    elseif dy_dx < lo
        out(Ix) = out(Ix-1) + lo*(time(Ix) - time(Ix-1));
    else
        out(Ix) = data(Ix);
    end
end
end