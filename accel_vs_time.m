[x,y,z,date_time,temp] = ...
    import_animal_tag_data_v2('yxz_test.TXT',1, 206);

%% Interpolatoin and data arangment
%shift time date and temp to be in line with accel
recoded_times=find(~isnat(date_time));
for n=2:length(recoded_times);
    %shift date time
    date_time(recoded_times(n)-1)=date_time(recoded_times(n));
    date_time(recoded_times(n))=[];
    
    %shift temp
    temp(recoded_times(n)-1)=temp(recoded_times(n));
    temp(recoded_times(n))=[];
end

%refind recorded times with new indecies
%time_interp=datetime;
time_ind=find(~isnat(date_time));
for n=1:(length(time_ind)-1);
    time_diff=date_time(time_ind(n+1))-date_time(time_ind(n)); %diff between recorded times
    num_of_point=time_ind(n+1)-time_ind(n); %number of points that need to be interp
    time_increase=time_diff/num_of_point; %step size of interp
    %fill in the blank times
    for k =time_ind(n)+1:time_ind(n+1)
        date_time(k)=date_time(k-1)+time_increase;
    end
end

%get rid off all bank rows except in accel
not_accel=isnan(x(1:end));
x(not_accel,:)=[];
y(not_accel,:)=[];
z(not_accel,:)=[];

%remove first time stamp so vectors are the same size
date_time(1:1)=[];

% %% Inital Plots
% 
% % %plot of the x data incudling gravity
% % figure(1)
% % plot(time_interp,x,'.','MarkerSize',14)
% % ylabel('x (g''s)')
% % xlabel('time (hh:mm:ss)')
% % title('x accel data including gravity')
% % 
% % %plot of the y data incudling gravity
% % figure(2)
% % plot(time_interp,y,'.','MarkerSize',14)
% % ylabel('y (g''s)')
% % xlabel('time (hh:mm:ss)')
% % title('y accel data including gravity')
% % 
% % %plot of the z data incudling gravity
% % figure(3)
% % plot(time_interp,z,'.','MarkerSize',14)
% % ylabel('z (g''s)')
% % xlabel('time (hh:mm:ss)')
% % title('z accel data including gravity')

%% Buuterwoth Filter
%implemtent a high pass Butterworth filter to remove gravitional data and
%isolate linear acceration

fc=0.1; %frequency cut off
fo=4; %filter order

%applie butter filter and output transfer function coffiecents
[b,a]=butter(fo,fc,'high');
x_bf=filter(b,a,x);
y_bf=filter(b,a,y);
z_bf=filter(b,a,z);

% %% ButterWorth Plots
% %plot of the x data befor and after bf
% figure(4)
% subplot(3,1,1) %comment if you want this plot on its own
% plot(date_time,x,'-','MarkerSize',14)
% hold on
% plot(date_time,x_bf,'-','MarkerSize',14)
% ylabel('x (g''s)')
% xlabel('time (hh:mm:ss)')
% title('x accel data before and after Butterworth filter')
% legend('before filter','after filter')
% 
% %plot of the y data befor and after bf
% %figure(5) %uncomment this and comment nl if you want this plot on its own
% subplot(3,1,2)
% plot(date_time,y,'-','MarkerSize',14)
% hold on
% plot(date_time,y_bf,'-','MarkerSize',14)
% ylabel('y (g''s)')
% xlabel('time (hh:mm:ss)')
% title('y accel data before and after Butterworth filter')
% legend('before filter','after filter')
% 
% %plot of the z data befor and after bf
% %figure(6) %uncomment this and comment nl if you want this plot on its own
% subplot(3,1,3)
% plot(date_time,z,'-','MarkerSize',14)
% hold on
% plot(date_time,z_bf,'-','MarkerSize',14)
% ylabel('z (g''s)')
% xlabel('time (hh:mm:ss)')
% title('z accel data before and after Butterworth filter')
% legend('before filter','after filter')

%% Brick Wall filter
sampling_rate=8;
x_brick=brick_wall(x, date_time,sampling_rate);
y_brick=brick_wall(y, date_time,sampling_rate);
z_brick=brick_wall(z, date_time,sampling_rate);

% %% Brick Wall plots
% figure(7)
% subplot(3,1,1) 
% plot(date_time,x,'-','MarkerSize',14)
% hold on
% plot(date_time,x_brick,'-','MarkerSize',14)
% ylabel('x (g''s)')
% xlabel('time (hh:mm:ss)')
% title('x accel data before and after brick wall filter')
% legend('before filter','after filter')
% 
% %plot of the y data befor and after brick wall
% %figure(5) %uncomment this and comment nl if you want this plot on its own
% subplot(3,1,2)
% plot(date_time,y,'-','MarkerSize',14)
% hold on
% plot(date_time,y_brick,'-','MarkerSize',14)
% ylabel('y (g''s)')
% xlabel('time (hh:mm:ss)')
% title('y accel data before and after brick wall filter')
% legend('before filter','after filter')
% 
% %plot of the z data befor and after brick wall
% subplot(3,1,3)
% plot(date_time,z,'-','MarkerSize',14)
% hold on
% plot(date_time,z_brick,'-','MarkerSize',14)
% ylabel('z (g''s)')
% xlabel('time (hh:mm:ss)')
% title('z accel data before and after brick wall filter')
% legend('before filter','after filter')

%% put cordiantes in shark frame
xgrav=x-x_brick; %accel due to gravity
ygrav=y-y_brick;
zgrav=z-z_brick;

%pre allocate memory
data_length=length(x);
x_shark=zeros(data_length,1);
y_shark=zeros(data_length,1);
z_shark=zeros(data_length,1);

phi=atan(ygrav./xgrav); %rotational angles IS THIS RIGHT?!?!?!?!
theta=(pi/2)-atan(zgrav./xgrav);

for i=1:data_length %think of a more clever/ less computaonal intesive way to do this
    %for example alot of these numbers stay the same, add code to only do
    %this if something changes
rotation=[cos(phi(i)).*cos(theta(i)), -1.*sin(phi(i)), -1.*cos(phi(i)).*sin(theta(i));
    sin(phi(i)).*cos(theta(i)), cos(phi(i)), -sin(phi(i)).*sin(theta(i));
    sin(theta(i)),0,cos(theta(i))];
postion_matrix=[x_brick(i);y_brick(i);z_brick(i)];
shark_cord=rotation*postion_matrix;
x_shark(i)=shark_cord(1);
y_shark(i)=shark_cord(2);
z_shark(i)=shark_cord(3);
end

%sanity check
mbefore_rotation=sqrt((x_brick.^2)+(y_brick.^2)+(z_brick.^2));
mafter_roation=sqrt((x_shark.^2)+(y_shark.^2)+(z_shark.^2));

