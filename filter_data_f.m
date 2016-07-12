function [date_time, comb_pitch, comb_roll, gravity, linear_accel] = filter_data_f(filename)

dt = 1/12; %sample period
%% Import Data
% Real-World Data
[ax,ay,az,gx,gy,gz,date_time,temp,pressure,bias] = ...
   import_tag_gyro2(filename);

%% Get pitch and roll from both sensors
% Accelerometer
x_f = ax; % - brick_wall(ax, dt);
y_f = ay; % - brick_wall(ay, dt);
z_f = az; % - brick_wall(az, dt);
[a_pitch, a_roll] = accel_pr(x_f, y_f, z_f);
a_pitch = unwrap_angles(a_pitch);
a_roll  = unwrap_angles(a_roll);

% Gyroscope
gx_d = gx .* dt;
gy_d = gy .* dt;
gz_d = gz .* dt;
g_pitch = cumsum(gx_d, 1);
g_roll  = cumsum(gy_d, 1);

% %% Combine Data with Complementary Filter
% A Complementary filter is a lot easier to implement than a Kalman filter
% (I'll eventually replace it). It's actually a special kind of Kalman
% filter.

% pweight = 0.05;
% 
% comb_pitch = zeros(size(a_pitch,1),1);
% ap = 0;
% for i = 1:size(comb_pitch,1)
%     ap = (1-pweight) * (g_pitch(i)) + pweight*(a_pitch(i));
%     comb_pitch(i) = ap;
% end
% 
% % Roll cannot be trusted when z is close to 0 (gimbal lock).
% % So we do a thing!
% rweight=0.05;
% comb_roll = zeros(size(a_roll,1),1);
% for i = 1:size(comb_roll,1)
%     ar = (1-rweight) * (g_roll(i)) + rweight*(a_pitch(i));
%     comb_roll(i) = ar;
% end

%% Combine Data with Kalman Filter
comb_pitch = kalman_ag(a_pitch, gx, dt);
comb_roll  = kalman_ag(a_roll, gy,  dt);

%% Remove Gravity, Rotate

% Convert angle to gravity vector and subtract
rp = deg2rad(comb_pitch);
rr = deg2rad(comb_roll);
cp = cos(rp);
gravity = [-sin(rp), cp.*sin(rr), cp.*cos(rr)];
linear_accel = [ax, ay, az] - gravity;

%% Here's a Bunch of Graphs
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
legend('x', 'y', 'z');
title('Gyroscope');
% Pitch
subplot(3, 1, 2);
hold on
plot(date_time, [a_pitch,a_roll], ':');
plot(date_time, [g_pitch,g_roll]);
hold off
ylabel('Deg');
legend('A.Pitch', 'A.Roll', 'G.Pitch', 'G.Roll');
title('Raw Pitch and Roll');

% Filter (Complementary or Kalman)
subplot(3, 1, 3);
plot(date_time, [comb_pitch, comb_roll]);
ylabel('Deg');
legend('Pitch', 'Roll');
title('P&R with Filter');

brush on

% figure(2);
% % Accel
% subplot(3, 1, 1);
% plot(date_time, [ax,ay,az]);
% ylabel('Acc. (g''s)');
% axis([-inf, inf, -8, 8]);
% legend('x', 'y', 'z');
% title('Accelerometer');
% 
% % Gravity
% subplot(3, 1, 2);
% plot(date_time, gravity);
% ylabel('g''s');
% axis([-inf, inf, -1, 1]);
% legend('x', 'y', 'z');
% title('Gravity (derived)');
% 
% % Linear Acceleration
% subplot(3, 1, 3);
% plot(date_time, linear_accel);
% ylabel('g''s');
% axis([-inf, inf, -8, 8]);
% legend('x', 'y', 'z');
% title('Linear Acceleration (der.)');

end
