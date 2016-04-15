[x_raw,y_raw,z_raw,datetime_raw,temp_raw] = ...
    import_animal_tag_data_v2('import_test_data_v2.TXT',1, 1490);
%import data (NOT NESSARY, get rid of this when haveing two arrys with all
%the accel data becomes a problem with larger data sets
x=x_raw;
y=y_raw;
z=z_raw;
%get rid off all bank rows except the first
not_accel=isnan(x(1:end));
not_accel(1,1)=0;
x(not_accel,:)=[];
y(not_accel,:)=[];
z(not_accel,:)=[];

%shift time date and temp to be in line with accel
time=datetime_raw; %get rid of this before larger data sets
temp=temp_raw;
recoded_times=find(~isnat(time));
for n=2:length(recoded_times);
    %shift date time
    time(recoded_times(n)-1)=time(recoded_times(n));
    time(recoded_times(n))=[];
    
    %shift temp
    temp(recoded_times(n)-1)=temp(recoded_times(n));
    temp(recoded_times(n))=[];
end

%refind recorded times with new indecies
time_interp=time;
time_ind=find(~isnat(time));
for n=1:(length(time_ind)-1);
    time_diff=time(time_ind(n+1))-time(time_ind(n)); %diff between recorded times
    num_of_point=time_ind(n+1)-time_ind(n); %number of points that need to be interp
    time_increase=time_diff/num_of_point; %step size of interp
    %fill in the blank times
    for k =time_ind(n)+1:time_ind(n+1)
        time_interp(k)=time_interp(k-1)+time_increase;
    end
end

% %plot of the x data incudling gravity
% figure(1)
% plot(time_interp,x,'.','MarkerSize',14)
% ylabel('x (g''s)')
% xlabel('time (hh:mm:ss)')
% title('x accel data including gravity')
% 
% %plot of the y data incudling gravity
% figure(2)
% plot(time_interp,y,'.','MarkerSize',14)
% ylabel('y (g''s)')
% xlabel('time (hh:mm:ss)')
% title('y accel data including gravity')
% 
% %plot of the z data incudling gravity
% figure(3)
% plot(time_interp,z,'.','MarkerSize',14)
% ylabel('z (g''s)')
% xlabel('time (hh:mm:ss)')
% title('z accel data including gravity')

%implemtent a high pass Butterworth filter to remove gravitional data and
%isolate linear acceration

fc=0.25; %frequency cut off
fo=4; %filter order

%applie butter filter and output transfer function coffiecents
[b,a]=butter(fo,fc,'high');
x_bf=filter(b,a,x(2:end));
y_bf=filter(b,a,y(2:end));
z_bf=filter(b,a,z(2:end));

%plot of the x data befor and after bf
figure(4)
plot(time_interp,x,'.','MarkerSize',14)
hold on
plot(time_interp(2:end),x_bf,'.','MarkerSize',14)
ylabel('x (g''s)')
xlabel('time (hh:mm:ss)')
title('x accel data before and after Butterworth filter')
legend('before filter','after filter')

%plot of the y data befor and after bf
figure(5)
plot(time_interp,y,'.','MarkerSize',14)
hold on
plot(time_interp(2:end),y_bf,'.','MarkerSize',14)
ylabel('y (g''s)')
xlabel('time (hh:mm:ss)')
title('y accel data before and after Butterworth filter')
legend('before filter','after filter')

%plot of the z data befor and after bf
figure(6)
plot(time_interp,z,'.','MarkerSize',14)
hold on
plot(time_interp(2:end),z_bf,'.','MarkerSize',14)
ylabel('z (g''s)')
xlabel('time (hh:mm:ss)')
title('z accel data before and after Butterworth filter')
legend('before filter','after filter')