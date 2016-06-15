function [ pitch, roll ] = accel_pr( x, y, z )
%ACCEL_PR Get pitch and roll from the accelerometer
%   This uses filtering and a bit of trig to get an approximation
%   of the pitch and roll from accelerometer inputs x, y, and z.
%   The coordinate system used is x=pitch, y=roll, and z=yaw.
%   There may be instability around certain angles (Gimbal lock &c.).

[b, a] = butter(4, 0.9, 'low');
x_f = filter(b, a, x);
y_f = filter(b, a, y);
z_f = filter(b, a, z);
% Stolen from:
% https://theccontinuum.com/2012/09/24/arduino-imu-pitch-roll-from-accelerometer/
pitch = rad2deg(atan2(y_f, sqrt(x_f.^2 + z_f.^2)));
roll = rad2deg(atan(-x_f ./ z_f));

end

