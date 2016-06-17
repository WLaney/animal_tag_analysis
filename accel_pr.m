function [ pitch, roll ] = accel_pr( x, y, z )
%ACCEL_PR Get pitch and roll from the accelerometer
%   This uses filtering and a bit of trig to get an approximation
%   of the pitch and roll from accelerometer inputs x, y, and z.
%   The coordinate system used is x=pitch, y=roll, and z=yaw.
%   There may be instability around certain angles (Gimbal lock &c.).

[b, a] = butter(2, 0.3, 'low');
x_f = filter(b, a, x);
y_f = filter(b, a, y);
z_f = filter(b, a, z);

% Stolen from our paper on accelerometry.
% roll is an approximation that prevents gimbal lock.
% makes me wonder if we should mix the original and new algorithms
pitch = rad2deg(atan2(y_f, sqrt(z_f .^ 2 + x_f .^ 2)));
sx = (x_f > 0) * 2 - 1;
mu = 0.01;
roll = rad2deg(atan2(z_f, sx .* sqrt(x_f .^ 2 + mu * y_f .^ 2)));

end

