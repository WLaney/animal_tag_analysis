function [ accel, times ] = import_dir( dirname, start_time )
% Import an entire directory into accelerometer and time data.
% Time data is offset from start_time, and dirname is the name of
% the directory to process.
listing = dir(dirname);
listing = listing(3:end);

%% Collect data from individual files
disp('Collecting data. This will take awhile...');
cells = {};
parfor i=1:length(listing)
    [accel, times] = import_file(strcat(dirname, '/', listing(i).name));
    cells{i} = {accel, times};
    disp(strcat('Finished: ', listing(i).name));
end

disp('Saving intermediate data...');
save(strcat(dirname, '-intermediate'), 'cells');

%% Move data into one giant array
accel = [];
times = [];
for i=1:length(cells)
   accel = [accel ; cells{i}{1}];
   times = [times ; cells{i}{2}];
end

times = start_time + seconds(times);

disp('Saving monolithic data...');
save(strcat(dirname, '-monolithic'), 'accel', 'times');

end