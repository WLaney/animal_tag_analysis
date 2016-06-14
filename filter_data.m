%% filter_data.m
% This sciprt takes raw sensor readouts and tries to convert them into
% a more physically descriptive format. For now, it tries to guess the
% pitch and roll of the tag through the accelerometer and gyroscope.
%% Import Data
% Real-World Data
% [ax,ay,az,gx,gy,gz,date_time,temp,pressure] = ...
%    import_tag_gyro2('data_w_gyro.txt');

% Simulated data
convert;
clear;
load('model/sim.mat', 'date_time', 'real_accel', 'real_gyro');
fa = real_accel';
fg = real_gyro';
ax = fa(1,:);
ay = fa(2,:);
az = fa(3,:);
gx = fg(1,:);
gy = fg(2,:);
gz = fg(3,:);

%% Get pitch and roll from both sensors
% Accelerometer
[b, a] = butter(3, 0.8, 'low');
ax_f = filter(b, a, ax);
ay_f = filter(b, a, ay);
az_f = filter(b, a, az);
% Trig
a_pitch = rad2deg(-sqrt(ay_f.^2 + az_f.^2) ./ ax_f.^2);
a_roll  = rad2deg(atan(ax_f ./ -az_f));
% Gyroscope
g_pitch = cumsum(gx ./ 12, 2);
g_roll  = cumsum(gy ./ 12, 2);

%% Plot
hold on
% Accel
subplot(4, 1, 1);
plot(date_time, [ax_f;ay_f;az_f]);
legend('x', 'y', 'z');
title('Accelerometer');
% Gyro
subplot(4, 1, 2);
plot(date_time, [gx;gy;gz]);
legend('x', 'y', 'z');
title('Gyroscope');
% Pitch
subplot(4, 1, 3);
plot(date_time, [a_pitch; g_pitch]);
legend('Accel', 'Gyro');
title('Pitch');
% Roll
subplot(4, 1, 4);
plot(date_time, [a_roll; g_roll]);
legend('Accel', 'Gyro');
title('Roll');
hold off