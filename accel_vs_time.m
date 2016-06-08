[x_accel,y_accel,z_accel,x_gyro,y_gyro,z_gyro,date_time,temp,pressure]...
    = import_tag_data_gyro('gyro_test_data.TXT',1, 269);

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
    
    %shift pressure
    pressure(recoded_times(n)-1)=temp(recoded_times(n));
    pressure(recoded_times(n))=[];
    
end

%refind recorded times with new indecies
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

%get rid off all bank rows
not_accel=isnan(x(1:end));
x_accel(not_accel,:)=[];
y_accel(not_accel,:)=[];
z_accel(not_accel,:)=[];
x_gyro(not_accel,:)=[];
y_gyro(not_accel,:)=[];
z_gyro(not_accel,:)=[];

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
