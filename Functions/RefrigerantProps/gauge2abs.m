function out = gauge2abs(in)
% Converts pressure signals at gauge pressure (bar) to absolute pressure
% (bar)
out = in + 1.01325;
end