function [date_time, comb_pitch, comb_roll, gravity, linear_accel] = filter_data_f(accel,gyro,date_time,pressure)
tic
dt = 1/25; %sample period

%% Get pitch and roll from both sensors
% Accelerometer
xyz_f=accel;
[a_pitch, a_roll] = accel_pr(xyz_f);
a_pitch = unwrap_angles(a_pitch);
a_roll  = unwrap_angles(a_roll);

% Gyroscope
gyro_d = gyro .* dt;
g_pitch = cumsum(gyro_d(:,1), 1);
g_roll  = cumsum(gyro_d(:,2), 1);

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
comb_pitch = kalman_ag(a_pitch, gyro(:,1), dt);
comb_roll  = kalman_ag(a_roll, gyro(:,2),  dt);

%% Remove Gravity, Rotate

% Convert angle to gravity vector and subtract
rp = deg2rad(comb_pitch);
rr = deg2rad(comb_roll);
cp = cos(rp);
gravity = [-sin(rp), cp.*sin(rr), cp.*cos(rr)];
%add check that this magnitude is 1
linear_accel = accel - gravity;

%% Here's a Bunch of Graphs
figure(1);
% Accel
subplot(3, 2, 1);
plot(date_time, accel);
ylabel('Acc. (g''s)');
axis([-inf, inf, -8, 8]);
legend('x', 'y', 'z');
title('Accelerometer');
% Gyro
subplot(3, 2, 2);
plot(date_time, gyro);
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

figure(2);
% Accel
subplot(3, 1, 1);
plot(date_time, [accel]);
ylabel('Acc. (g''s)');
axis([-inf, inf, -8, 8]);
legend('x', 'y', 'z');
title('Accelerometer');

% Gravity
subplot(3, 1, 2);
plot(date_time, gravity);
ylabel('g''s');
axis([-inf, inf, -1, 1]);
legend('x', 'y', 'z');
title('Gravity (derived)');

% Linear Acceleration
subplot(3, 1, 3);
plot(date_time, linear_accel);
ylabel('g''s');
axis([-inf, inf, -8, 8]);
legend('x', 'y', 'z');
title('Linear Acceleration (der.)');
toc
end
