function [accel,gyro,date_time,temp,pressure] = import_tag_manual(filename)
% My own attempt to re-write the import code for the sake of efficiency.
fp = fopen(filename);
if (fp == -1)
   error(strcat('Could not open ', filename));
end

NAN = NaN;

% Initial setup
accel = [NAN, NAN, NAN];
gyro = [NAN, NAN, NAN];
temp = NAN;
pressure = NAN;
% Throw away header row
fgetl(fp);
% Get initial date-time
line = strsplit(fgetl(fp), ',', 'CollapseDelimiters', false);
date_time = datetime(line(7), 'InputFormat', 'y-M-d h:m:s');

% Parse each row
while true
    sline = fgetl(fp);
    if sline == -1 ; break ; end
    line = strsplit(sline, ',', 'CollapseDelimiters', false);
    if ismember(line{1}, '0123456789+-.eEdD') % short-term lin
        accel = [accel ; [str2double(line{1}), str2double(line{2}), str2double(line{3})]];
        gyro = [gyro ;   [str2double(line{4}), str2double(line{5}), str2double(line{6})]];
        date_time = [date_time ; NaT];
        temp = [temp ; NAN];
        pressure = [pressure ; NAN];
    else %long-term
        date_time = [date_time ; datetime(line(7), 'InputFormat', 'y-M-d h:m:s')];
        temp = [temp ; str2double(line(8))];
        pressure = [pressure ; str2double(line(9))];
    end
end

fclose(fp);
end