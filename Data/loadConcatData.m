% Script for loading and concatenating data from both the first and second
% days of the space filling design test points.

load('TD_2021-01-28_07-54-16.mat'); TD1 = TD;
load('TD_2021-01-29_07-24-54.mat'); TD2 = TD;
load('comprClutch.mat')

% Remove datetime difference (in order to concatenate data maintaining a fixed sample rate)
difference = TD2.Date_Time(1) - TD1.Date_Time(end);
TD2.Date_Time = TD2.Date_Time - difference + seconds(1);
% Also remove the difference from the compressor clutch data
comprClutch.comprClutchDateTime(comprClutch.comprClutchDateTime > TD1.Date_Time(end)) = ...
    comprClutch.comprClutchDateTime(comprClutch.comprClutchDateTime > TD1.Date_Time(end)) - difference + seconds(1);

TD = [TD1; TD2];