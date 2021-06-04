function out = interpNaN(in)
% Finds NaNs in data and interpolates around them. For NaNs at start and
% end of files, "next" and "previous" options are used.

out = in;
nans = isnan(in);
samples = 1:numel(in);
out(nans) = interp1(samples(~nans), in(~nans), samples(nans));

% NOTE: YET TO IMPLEMENT NEXT AND PREVIOUS PARTS

end