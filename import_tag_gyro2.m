function [ax,ay,az,gx,gy,gz,dt,temp,pressure] = import_tag_gyro2()
%Import tag data from the gyroscope, interpolating time.
%   Done mainly to get more familiar with MATLAB.
fp = fopen('data_w_gyro.txt');
if fp == -1
    error(['Could not open ' 'data_w_gyro.txt']);
end

TAB = sprintf('\t');

%% Get Raw Data
sdata = []; % gx gy gz ax ay az
% Initial time data
tline = fgetl(fp);
dt = [datetime(tline(7:end), 'InputFormat', 'y-M-d H:m:s')];
temp = [0];
pressure = [0];
while true
   tline = fgetl(fp);
   if ~ischar(tline), break, end
   if tline(1) == TAB
       line = tline(7:end);
       tabi = strfind(line, TAB);
       
       date_string = line(1:(tabi-1));
       dt(end) = datetime(date_string, 'InputFormat', 'y-M-d H:m:s');
       
       data_string = line((tabi+1):end);
       data = sscanf(data_string, '%f'); % TODO add in pressure
       temp(end) = data;
       pressure(end) = 0;
   else
       sdata = [sdata sscanf(tline, '%f %f %f %f %f %f')];
       if (size(sdata,2) ~= 1)
           dt = [dt NaT];
           temp = [temp temp(end)];
           pressure = [pressure pressure(end)];
       end
   end
end

fclose(fp);

%% Datetime interpolation
