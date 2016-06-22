function [ date_time, fake_gyro, fake_accel, ...
    real_gyro, real_accel, angles] = import_test( testname )
%IMPORT_TEST Load the matrices from a test folder.
%   This takes the name of a test folder ('gimbal' -> 'model/tests/gimbal')
%   and returns the matrices contained therein.

test_folder = strcat('model/tests/', testname, '/');
fake_fname   = strcat(test_folder, 'fake.txt');
real_fname   = strcat(test_folder, 'real.txt');
angle_fname = strcat(test_folder, 'angles.txt');

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
angles = fscanf(anglef, '%f', [3, Inf])';

fclose(fakef);
fclose(realf);
fclose(anglef);
end

