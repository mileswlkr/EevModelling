function out = saturate(in,lo,up)
    % Saturates the signal to the values specified by lo and up
    out = in;
    % Lower limits:
    if numel(lo) == 1
        out(in < lo) = lo;
    else
        out(in < lo) = lo(in < lo);
    end
    % Upper limits:
    if numel(up) == 1
        out(in > up) = up;
    else
        out(in > up) = up(in > up);
    end
end