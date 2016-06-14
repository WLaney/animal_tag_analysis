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

%% Get pitch and roll5 from both sensors
% Accelerometer
[b, a] = butter(3, 0.7, 'low');
ax_f = filter(b, a, ax);
ay_f = filter(b, a, ay);
az_f = filter(b, a, az);
% Trig
a_pitch = rad2deg(atan2(sqrt(ay_f.^2 + az_f.^2), -ax_f.^2));
a_roll = rad2deg(atan2(-az_f, ax_f));
% If we pitch the tag a certain way, roll becomes irrelevant.
% But if we roll the tag a certain way, pitch becomes irrelevant.
% The solution is to limit one angle to -90 to 90 degrees.
% I arbitrarily chose pitch.
a_pitch = max(-180, min(180, a_pitch));
a_roll = max(-90, min(90, a_roll));
% Gyroscope
g_pitch = cumsum(gx, 1);
g_roll  = cumsum(gy, 1);

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