[ax,ay,az,gx,gy,gz,date_time,temp,pressure] = ...
    import_tag_gyro2('data_w_gyro.txt');

%% Get pitch and yaw from both sensors
% Accelerometer - filter+trig
ax_f = brick_wall(ax', date_time', 12)';
ay_f = brick_wall(ay', date_time', 12)';
az_f = brick_wall(az', date_time', 12)';
a_pitch = atan(ay_f ./ sqrt(ax_f .^ 2 + az_f .^ 2));
a_roll  = atan(-ax_f ./ az_f);

% Gyroscope - integrate
g_pitch = cumsum(gx, 1);
g_roll  = cumsum(gy, 1);

hold on
subplot(2,1,1);
plot(date_time, [a_pitch; g_pitch]);
legend('Accel', 'Gyro');
title('Pitch');

subplot(2,1,2);
plot(date_time, [a_roll; g_roll]);
legend('Accel', 'Gyro');
title('Roll');
hold off