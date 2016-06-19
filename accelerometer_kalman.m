%% Accelerometer-only Kalman filter
% A test Kalman filter that, given inputs and some information about
% accelerometer and system noise, filters the noise out.

%% Get Data
[ax, ay, az, ~, ~, ~, date_time, ~, ~] = ...
    import_tag_gyro2('data_w_gyro.txt');
%% Run Kalman Filter
data = [ax ; ay ; az]';
% Our estimate/output.
% For lack of a better first value, we use data(:,1);
mu = zeros(size(data));
mu(1,:) = data(1,:);
% Uncertainty matrix
sigma = eye(3);

% System and measurement noise. I don't know these yet.
s_noise = eye(3) * 0.02;
m_noise = eye(3) * 0.015;

for i = 2:size(data, 1)
    % Prediction step
    sigma_guess = sigma + s_noise;
    % Update step
    k = sigma_guess / (sigma_guess + m_noise);
    mu(i,:) = mu(i-1,:) + (data(i,:) - mu(i-1,:) * k);
    sigma = (eye(3) - k) * sigma_guess;
end

%% Plot Against Raw/Lowpass
[b, a] = butter(3, 0.15);
data_f = filter(b, a, data, [], 1);

plot(date_time, [ax' , data_f(:,1), mu(:,1)]);
legend('raw', 'lowpass', 'kalman');
title('Accelerometer-Only Kalman');