function out = filterCompr(in)
% Function to ensure the compressor data is always filtered the same way

fs = 1; % Sample frequency (Hz)
fpass = 0.01; % Lowpass frequency

out = lowpass(in, fpass, fs);

end