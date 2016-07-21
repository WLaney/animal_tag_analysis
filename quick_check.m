function [  ] = quick_check( accel, gyro, date_time )
figure(1)
subplot(3,1,1)
plot(date_time,accel(:,1),'.')
title('Raw X acceleration')
xlabel('time')
ylabel('accel X (g''s)')

subplot(3,1,2)
plot(date_time,accel(:,2),'.')
title('Raw Y acceleration')
xlabel('time')
ylabel('accel Y (g''s)')

subplot(3,1,3)
plot(date_time,accel(:,3),'.')
title('Raw Z acceleration')
xlabel('time')
ylabel('accel Z (g''s)')


end

