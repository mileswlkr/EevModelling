function out = delayRemove(in,Ns)
% This function removes delay, by advancing the output forwards in time.
% For simplicity, the number of samples to shift is specified rather than
% the time delay. The last Ns samples are held at the final value.

out = in;
out(1:(end - Ns)) = out((Ns+1):end);
out((end-Ns):end) = out((end-Ns));

end