function [  ] = raw_graphs( times, accel )
%This function outputs graphs of the raw GCDC data before any data anaylis 
%is done. The only anaylsis preformed is converting the data into g's

%define constant
raw2g=2048; %counts/g

accel_g=(double(accel))./(raw2g);

%plot x
figure(1)
plot(times,accel_g(:,1),'.-')
xlabel('time')
ylabel('acceration (g''s)')
title('Raw X acceleration')

%plot y
figure(2)
plot(times,accel_g(:,2),'.-')
xlabel('time')
ylabel('acceration (g''s)')
title('Raw Y acceleration')

%plot z
figure(3)
plot(times,accel_g(:,3),'.-')
xlabel('time')
ylabel('acceration (g''s)')
title('Raw Z acceleration')

end

