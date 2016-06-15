function [ ] = run_accelerometer_test( testname )
% Compare the accelerometer's estimation of the pitch and roll against
% the actual angles graphically.
% testname is the name of a model/tests folder.

test_folder = strcat('model/tests/', testname, '/');
fake_name   = strcat(test_folder, 'fake.txt');
real_name   = strcat(test_folder, 'real.txt');
angles_name = strcat(test_folder, 'angles.txt');
[date_time, ~, fake_accel, ~, real_accel, angles] = ...
    convert(fake_name, real_name, angles_name);

[af_pitch, af_roll] = accel_pr(fake_accel(:,1), fake_accel(:,2), fake_accel(:,3));
[ar_pitch, ar_roll] = accel_pr(real_accel(:,1), real_accel(:,2), real_accel(:,3));

%% Plotting
subplot(3, 1, 1);
hold on
plot(date_time, fake_accel);
plot(date_time, real_accel, ':');
axis([-inf inf -8 8]);
legend('noise-x', 'noise-y', 'noise-z', 'real-x', 'real-y', 'real-z');
title('Accelerometer Reads');
hold off
subplot(3, 1, 2);
plot(date_time, angles);
axis([-inf inf -360 360]);
legend('pitch', 'roll', 'yaw');
title('Actual Angles');
subplot(3, 1, 3);
hold on
plot(date_time, [af_pitch, af_roll], ':');
plot(date_time, [ar_pitch, ar_roll]);
hold off
axis([-inf inf -360 360]);
legend('noise+pitch', 'noise+roll', 'pitch', 'roll');
title('Accelerometer Pitch & Roll');

end

