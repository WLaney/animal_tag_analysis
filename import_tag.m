function [accel,gyro,date_time,temp,pressure,date_time_short] = import_tag(filename, short)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [accel,gyro,DATE_TIME,TEMP,PRESSURE] = import_tag(FILENAME, short)
%   Reads data from text file FILENAME for the default selection. Short is
%   an optional paramter that when set to true retuns temp, pressure, and
%   date_time called date_time_short without blank rows. The default value
%   of short is false

%% Import raw data
fp = fopen(filename);
if (fp == -1)
   error(strcat('Could not open ', filename));
end

cells = textscan(fp, '%f%f%f%f%f%f%{y-M-d H:m:s}D%f%f', 'Delimiter', ',', ...
    'Headerlines', 1);
accel = [cells{1}, cells{2}, cells{3}];
gyro = [cells{4}, cells{5}, cells{6}];
date_time = cells{7};
temp = cells{8};
pressure = cells{9};

fclose(fp);

%% Create short versions if needed
% Short date-time, temp, pressure (no NaTs)
if short==true
    %Remove NaTs from date-time
    date_time_short=date_time(~isnat(date_time));
    %First row should be removed (no temp/pressure)
    date_time_short(1)=[];
    
    %get rid of all blank rows in pressure and temp
    not_data=isnan(temp(1:end));
    temp(not_data,:)=[];
    pressure(not_data,:)=[];
else
    date_time_short=[];
end
% 
%% Datetime interpolation
%interpolate the data time between RTC writes
inds = find(~isnat(date_time));
% from 1 to (inds-1):
%   get the last time value and the current one
%   find the number of indices between the two
%   linspace() the two and assign it to the date_time
for n=1:(length(inds)-1)
    i_old = inds(n);
    i_new = inds(n+1);
    t_old = date_time(i_old);
    t_new = date_time(i_new);
    date_time(i_old:(i_new-1)) = linspace(t_old, t_new, i_new-i_old);
end
% 
%interpreter doent work with only one time stamp so data at the very end of
%the file can't be interperpolated. This is not much
%data so we are just going to remove it
data_end=isnat(date_time); %find uninterpolated data

%we should not have to remove very many data points, if we do there is
%probably a problem with the data
max_data_removal= 200; %the max amount of data that is safe to remove
if length(data_end) > max_data_removal
    warning(['There is more data without a closing time'...
    ' then expected. Please double check the datafile for problems'])
end

date_time(data_end)=[]; %remove data
accel(data_end,:)=[];
gyro(data_end,:)=[];

%% Remove Blank Rows

%get rid off all bank rows in accel and gyro
not_data=isnan(accel(:,1));
accel(not_data,:)=[];
gyro(not_data,:)=[];

%remove unneeded time stamps, this makes accel/gyro the same length as
%date_time. The removed times corosponed to when the RTC wrote the time to
%the SD, this does not occure simotanusly with any accel/gyro read
date_time(not_data)=[];
warning('Save workspace so you do not need to import the data again')

end
