function [ accel, times ] = import_file( filename )
% Import the data from an accelerometer CSV into a MATLAB matrix.
% accel is 3 column vectors of [x,y,z] data.
% times is a column vector of seconds since logging started.
fp = fopen(filename);

if (fp == -1)
    error(strcat('Couldn''t open file ', filename))
end

cells = textscan(fp, '%f32%d16%d16%d16', 'Delimiter', ',', 'CommentStyle', ';');

accel = [cells{2}, cells{3}, cells{4}];
times = cells{1};

fclose(fp);

end