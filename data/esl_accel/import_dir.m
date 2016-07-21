function [ cells ] = import_dir( dirname )
% Import an entire directory into accelerometer and time data.
% Time data is offset from start_time, and dirname is the name of
% the directory to process.
% TODO Describe cell structure
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

end