function [ angle ] = kalman_ag( a_ang, g_vel, dt )
% A Kalman filter based on acceleration and gyroscope inputs that tries
% to combine the two signals into the "correct" angle.
%
% a_ang is the angle as guessed by the accelerometer. g_vel is the
% instantaneous angular velocity. dt is the sample period.

% Various constants. Don't worry about them.
A = [1, -dt ; 0, 1];
B = [dt ; 0];
C = [1, 0 ; 0, 1];

% System noise and measurement noise, respectively. The former is
% for currents/vibrations; the latter is for sensor noise. We need to
% get measurements or estimations for both, eventually.
sytem_noise=0.2; %guess
measrment_noise=0.4; %guess
Q = eye(2) * sytem_noise;
R = eye(2) * measrment_noise;

% Reshape inputs
z = reshape(a_ang, min(size(a_ang)), length(a_ang));
z = [z; zeros(1, length(z))];
y = reshape(g_vel, min(size(a_ang)), length(a_ang));

% [angle , bias]
inital_sigma_guess=0.3; %this value dosen,t mater bc filter will quickly converge
mu = zeros(size(z)); %current filter guess, mean of what it should be
sigma = inital_sigma_guess * eye(2); %BEN PUT COMMENT
% 
% figure(20);
% hs11 = animatedline('Color', 'r');
% hs12 = animatedline('Color', 'g');
% hs21 = animatedline('Color', 'b');
% hs22 = animatedline('Color', 'y');

for i=2:length(mu)
    % Prediction step
    % Use the gyroscope to figure out where we're going
    mu_guess = A*mu(:,i-1) + B*y(:,i);
    sigma_guess = A*sigma*A' + Q;
%     addpoints(hs11, i, sigma_guess(1,1));
%     addpoints(hs12, i, sigma_guess(1,2));
%     addpoints(hs21, i, sigma_guess(2,1));
%     addpoints(hs22, i, sigma_guess(2,2));
    % Correct gyroscope drift against the accelerometer
    k = sigma_guess*C' / (C*sigma_guess*C' + R);
    mu(:,i) = mu_guess + k*(z(:,i) - C*mu_guess);
    sigma = (eye(2) - k*C)*sigma_guess;
end

% drawnow

angle = mu(1,:)';

% Questions:
% - Why is the first set of sensor measurements discarded?

end
