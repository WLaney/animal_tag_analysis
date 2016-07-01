global dt;
dt = 1/12;
%% filter_data.m
% This script takes raw sensor readouts and tries to convert them into
% a more physically descriptive format. For now, it tries to guess the
% pitch and roll of the tag through the accelerometer and gyroscope. It
% then uses that estimate to remove the gravity vector from the data.
%
% There are currently a couple of limitations:
% - Accelerometer pitch is limited to +-90 degrees. This is due to multiple
%   solution reasons that I don't quite yet understand, but it is
%   industry standard, and our shark is more likely to barrel roll than
%   it is to loop-de-loop.
%% Import Data
% Real-World Data
[ax,ay,az,gx,gy,gz,date_time,temp,pressure] = ...
   import_tag_gyro2('data_w_gyro.txt');

%% Get pitch and roll from both sensors
% Accelerometer
x_f = ax - brick_wall(ax, dt);
y_f = ay - brick_wall(ay, dt);
z_f = az - brick_wall(az, dt);
[a_pitch, a_roll] = accel_pr(x_f, y_f, z_f);

% For instability reasons, accelerometer pitch is limited to +-90 degrees.
% Roll is limited to +-180 degrees. This choice is arbitrary, and we can
% change it if sharks ever decide to swim upside down.

% Gyroscope
g_pitch = mod(cumsum(gx .* dt, 1) + 180, 360) - 180;
g_roll  = mod(cumsum(gy .* dt, 1) + 180, 360) - 180;

%% Combine Data with Complementary Filter
% A Complementary filter is a lot easier to implement than a Kalman filter
% (I'll eventually replace it). It's actually a special kind of Kalman
% filter.

% Normally, the weights between gyroscope and accelerometer would be
% determined via the Kalman filter's predictions. Here, though, we use
% the fact that the accelerometer is most likely to be right when its
% length is 1g (no linear acceleration, probably) and the current
% g_pitch and g_roll are not out of whack.
distance = abs(sqrt(ax .^ 2 + ay .^ 2 + az .^ 2) - 1);
weight = 0.1 * max(0, 1 - (62.5 * distance) .^ 0.4);
weight = weight .* (g_pitch > -90) .* (g_pitch < 90);

comp_pitch = zeros(size(a_pitch,1),1);
ap = 0;
for i = 1:size(comp_pitch,1)
    ap = weight(i) * a_pitch(i) + (1 - weight(i)) * (ap + gx(i) ./ 12);
    comp_pitch(i) = ap;
end

comp_roll = zeros(size(a_roll,1),1);
ar = 0;
for i = 1:size(comp_roll,1)
    ar = weight(i) * a_roll(i) + (1 - weight(i)) * (ar + gy(i) ./ 12);
    comp_roll(i) = ar;
end

% %% Combine Data with Kalman Filter
% kal_pitch = kalman_ag(a_pitch, gx, dt);
% kal_roll  = kalman_ag(a_roll, gy,  dt);

%


%% Here's a Bunch of Freaking Graphs
figure(1);
% Accel
subplot(3, 2, 1);
plot(date_time, [ax,ay,az]);
ylabel('Acc. (g''s)');
axis([-inf, inf, -8, 8]);
legend('x', 'y', 'z');
title('Accelerometer');
% Gyro
subplot(3, 2, 2);
plot(date_time, [gx,gy,gz]);
ylabel('Ang. Vel (dps)');
axis([-inf, inf, -360, 360]);
legend('x', 'y', 'z');
title('Gyroscope');
% Pitch
subplot(3, 1, 2);
hold on
plot(date_time, [a_pitch,a_roll], ':');
plot(date_time, [g_pitch,g_roll]);
hold off
ylabel('Deg');
axis([-inf, inf, -180, 180]);
legend('A.Pitch', 'A.Roll', 'G.Pitch', 'G.Roll');
title('Raw Pitch and Roll');

% Complementary Filter
subplot(3, 1, 3);
plot(date_time, [comp_pitch, comp_roll]);
ylabel('Deg');
axis([-inf, inf, -180, 180]);
legend('Pitch', 'Roll');
title('P&R with Complementary Filter');

% % Plot
% subplot(3, 1, 3);
% plot(date_time, [kal_pitch,kal_roll]);
% ylabel('Deg');
% axis([-inf, inf, -180, 180]);
% legend('Pitch', 'Roll');
% title('P&R with Kalman Filter');