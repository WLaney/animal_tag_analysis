function [ accel, times ] = import_file( filename )
% Import the data from an accelerometer CSV into a MATLAB matrix.
% accel is 3 column vectors of [x,y,z] data.
% times is a column vector of seconds since logging started.
accel = [];
times = [];
fp = fopen(filename);
if (fp == -1)
    error(strcat('Couldn''t open file ', filename))
end

while true
   line = fgetl(fp);
   if ~ischar(line) % eof
       break
   elseif line(1) == ';' % skip comments
       continue
   else % data
       lcs = strsplit(line, ',');
       times = [times ; str2double(lcs{1})];
       accel = [accel ; [str2double(lcs{2}), str2double(lcs{3}), str2double(lcs{4})]];
   end
end

% why is there no str2int? Did I just not look?
accel = int32(accel);
fclose(fp);
end