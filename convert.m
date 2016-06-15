function [date_time, fake_gyro, fake_accel, real_gyro, real_accel, angles] = ...
    convert(fake_fname, real_fname, angle_fname)
% Turns simulated test data into matrices.
% Test data can be found in the model/tests directory, and follows the
% format of:
% y-m-d h:m:s:[microseconds] [gyroscope data] [accelerometer data]
% "fake" data has added noise to simulate gyroscope drift and accelerometer
% instability. "real" data shows the actual gravity vector and angular
% velocity.

fakef = fopen(fake_fname, 'r');
cells = textscan(fakef, '%s %s %f %f %f %f %f %f');
dts = strcat(cells{1}, '-', cells{2});
date_time = datetime(dts, 'InputFormat', 'M-d-y-H:m:s:SSSSSS');

fake_gyro  = [cells{3:5}];
fake_accel = [cells{6:8}];

realf = fopen(real_fname, 'r');
cells = textscan(realf, '%s %s %f %f %f %f %f %f');
% date_time should be the same for both
real_gyro  = [cells{3:5}];
real_accel = [cells{6:8}];

anglef = fopen(angle_fname, 'r');
angles = fscanf(anglef, '%f', [3, Inf]);

fclose(fakef);
fclose(realf);

end
