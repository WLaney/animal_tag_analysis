[x_raw,y_raw,z_raw,date_raw,time_raw,temp_raw] = ...
    import_animal_tag_data('DATA.TXT',1, 803);
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

%shift time to be in line with accel
time=time_raw; %get rid of this before larger data sets
recoded_times=find(~isnat(time));
for n=2:length(recoded_times);
    time(recoded_times(n)-1)=time(recoded_times(n));
    time(recoded_times(n))=[];
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
figure(1)
plot(time_interp,x,'.')
figure(2)
plot(time_interp,y,'.')
figure(3)
plot(time_interp,z,'.')