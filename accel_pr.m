function [ pitch, roll ] = accel_pr( x, y, z )
%ACCEL_PR Get pitch and roll from the accelerometer
%   This uses filtering and a bit of trig to get an approximation
%   of the pitch and roll from accelerometer inputs x, y, and z.
%   The coordinate system used is x=pitch, y=roll, and z=yaw.
%   There may be instability around certain angles (Gimbal lock &c.).

% Stolen from our accelerometry paper (Eqn. 25)
% Reordering of coordinates, inverting pitch intentional
roll  = rad2deg(atan2(x, z));
pitch = rad2deg(atan2(y, sqrt(x.^2 + z.^2)));

% Attempted workaround from the same paper (Eqn. 37)
% that tries to avoid gimbal lock
% sign_z = (z > 0) * 2 - 1;
% mu = 0.1;
% roll  = rad2deg(atan2(x, sign_z .* sqrt(z.^2 + mu*y.^2)));
% pitch = rad2deg(atan2(y, sqrt(x.^2 + z.^2)));

end