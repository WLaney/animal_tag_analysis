[x,y,z,datetime,temp] = ...
    import_animal_tag_data_v2('yxz_test.TXT',1, 206);

%shift time date and temp to be in line with accel
recoded_times=find(~isnat(datetime));
for n=2:length(recoded_times);
    %shift date time
    datetime(recoded_times(n)-1)=datetime(recoded_times(n));
    datetime(recoded_times(n))=[];
    
    %shift temp
    temp(recoded_times(n)-1)=temp(recoded_times(n));
    temp(recoded_times(n))=[];
end

%refind recorded times with new indecies
%time_interp=datetime;
time_ind=find(~isnat(datetime));
for n=1:(length(time_ind)-1);
    time_diff=datetime(time_ind(n+1))-datetime(time_ind(n)); %diff between recorded times
    num_of_point=time_ind(n+1)-time_ind(n); %number of points that need to be interp
    time_increase=time_diff/num_of_point; %step size of interp
    %fill in the blank times
    for k =time_ind(n)+1:time_ind(n+1)
        datetime(k)=datetime(k-1)+time_increase;
    end
end

%get rid off all bank rows except in accel
not_accel=isnan(x(1:end));
x(not_accel,:)=[];
y(not_accel,:)=[];
z(not_accel,:)=[];

%remove first time stamp so vectors are the same size
datetime(1:1)=[];

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
x_bf=filter(b,a,x);
y_bf=filter(b,a,y);
z_bf=filter(b,a,z);

%plot of the x data befor and after bf
figure(4)
subplot(3,1,1) %comment if you want this plot on its own
plot(datetime,x,'-','MarkerSize',14)
hold on
plot(datetime,x_bf,'-','MarkerSize',14)
ylabel('x (g''s)')
xlabel('time (hh:mm:ss)')
title('x accel data before and after Butterworth filter')
legend('before filter','after filter')

%plot of the y data befor and after bf
%figure(5) %uncomment this and comment nl if you want this plot on its own
subplot(3,1,2)
plot(datetime,y,'-','MarkerSize',14)
hold on
plot(datetime,y_bf,'-','MarkerSize',14)
ylabel('y (g''s)')
xlabel('time (hh:mm:ss)')
title('y accel data before and after Butterworth filter')
legend('before filter','after filter')

%plot of the z data befor and after bf
%figure(6) %uncomment this and comment nl if you want this plot on its own
subplot(3,1,3)
plot(datetime,z,'-','MarkerSize',14)
hold on
plot(datetime,z_bf,'-','MarkerSize',14)
ylabel('z (g''s)')
xlabel('time (hh:mm:ss)')
title('z accel data before and after Butterworth filter')
legend('before filter','after filter')