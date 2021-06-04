function steady = mvngWndwSteady(time,data,Ts,Tw,height)
% Function for evaluating if a signal is steady state. This method uses a
% moving window approach and outputs a boolean vector:
% - The derivative of the signal is taken at each point and averaged over
% the whole window. It must be sufficiently close to zero.
% - A window allowance is also defined and the signal must stay within it's
% bounds over the windown length. This is an allowance for noise.

% time = datetime data
% data = the data under scrutiny
% Ts = Sample time steps (s). Computations taken every Ts seconds
% Tw = the length/width of the window to check for steady state (s)
% height = window height (specific to data)

% Find the number of samples of data in the time window from the start
ns = sum(time < time(1) + seconds(Tw));

% Find the number of samples between the sampling period
timerel = seconds(time - time(1));
samples = floor(interp1(timerel, 1:numel(timerel), 0:Ts:timerel(end)));

% Initialise steady vector
steady = true(size(samples));

for Ix = 1:numel(samples)
    if max([1,Ix-ns]) == 1
        % Assume not steady if too close to start of file
        steady(Ix) = false;
    else
        timew = datenum(time(max([1,samples(Ix)-ns]):samples(Ix)))*24*60^2; % time data for the window
        timew = timew-timew(1);
        dataw = data(max([1,samples(Ix)-ns]):samples(Ix)); % variable data for the window
        
        % Window height check:
        if max(dataw) > mean(dataw)+height/2 || min(dataw) < mean(dataw)-height/2
            % Not steady if signal leaves window height
            steady(Ix) = false;
            continue % skip to next iteration of for loop
        end
        
        % Find the average gradient:
        coeffs = [timew, ones(size(timew))]\dataw;
        % Assume that the maximum allowable gradient is half the window
        % height:
        if abs(coeffs(1)) > height/2/timew(end)
            % Change too large inside window
            steady(Ix) = false;
            continue % skip to next iteration of for loop
        end
        
        % Pick up maxima and minima inside the window by finding first and
        % second half gradients
        coefffh = [timew(1:floor(end/2)), ones(size(timew(1:floor(end/2))))]\dataw(1:floor(end/2)); % First half of window
        coeffsh = [timew(ceil(end/2):end), ones(size(timew(ceil(end/2):end)))]\dataw(ceil(end/2):end); % Second half of window
        
        if abs(coefffh(1)) > height/2/timew(end) && abs(coeffsh(1)) > height/2/timew(end)
            % If we're at this point of the script and these values are
            % both large it suggests a maximum or minimum has occured in
            % the window:
            steady(Ix) = false;
        end
    end
end

% Resample "steady" vector:
steady = interp1(samples, double(steady), 1:numel(data), 'previous'); % Convert to double in order to use interp1 
steady = steady > 0.5; % Change back to logical vector

end