function [  ] = quick_check( accel, gyro, date_time )
%make plots of raw XYZ acceration, angular velocity, and acceration
%magnitude. This is for inital data intgerty checks

%check that date_time is in order
time_in_order=issorted(date_time);
if time_in_order == 0
    error('date times are not in order')
end

%X Y Z raw accel data
figure(1)
subplot(3,1,1)
plot(date_time,accel(:,1),'.')
title('Raw X acceleration vs. Time')
xlabel('time')
ylabel('accel X (g''s)')

subplot(3,1,2)
plot(date_time,accel(:,2),'.')
title('Raw Y acceleration vs. Time')
xlabel('time')
ylabel('accel Y (g''s)')

subplot(3,1,3)
plot(date_time,accel(:,3),'.')
title('Raw Z acceleration vs Time')
xlabel('time')
ylabel('accel Z (g''s)')

%calulate the magnitude of acceration
accel_mag=sqrt(((accel(:,1).^2))+((accel(:,2).^2))+((accel(:,3).^2)));
figure(2)
plot(date_time,accel_mag,'.')
title('Magnitude of raw acceration vs. Time')
xlabel('time')
ylabel('accel (g''s)')

%X Y Z raw gyro data
figure(3)
subplot(3,1,1)
plot(date_time,gyro(:,1),'.')
title('Raw X angular velocity vs. Time')
xlabel('time')
ylabel('angular velocity X (deg/sec)')

subplot(3,1,2)
plot(date_time,gyro(:,2),'.')
title('Raw Y angular velocity vs. Time')
xlabel('time')
ylabel('angular velocity Y (deg/sec)')

subplot(3,1,3)
plot(date_time,gyro(:,3),'.')
title('Raw Z angular velocity vs Time')
xlabel('time')
ylabel('angular velocity Z (deg/sec)')
end

