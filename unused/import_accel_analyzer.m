function [ x, y, z, dt ] = import_accel_analyzer( filename )
%Import and resample data from the Accelerometer Analyzer app.

fp = fopen(filename);
if fp == -1
    error(strcat('Could not load', filename, '.'));
end

%% Import Raw Data
line = fgetl(fp);
data = [];
while ischar(line)
    if size(line,1) > 0 && line(1) ~= '#'
        data = [data ; sscanf(line, '%f %f %f %f')'];
    end
    line = fgetl(fp);
end

%% Interpolate

% 40 instants / sample -> 25hz
% We want 12Hz instead.
times = cumsum(data(:,4));
fs = 1/40 * 1/2;
x = resample(data(:,1), times, fs);
y = resample(data(:,2), times, fs);
z = resample(data(:,3), times, fs);

% Simulated datetime
dt = milliseconds(1:size(x,1))';

% x = data(1,:);
% y = data(2,:);
% z = data(3,:);
% dt = data(4,:);
fclose(fp);

end

