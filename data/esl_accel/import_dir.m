function [ accel, times ] = import_dir( dirname, start_time )
% Import an entire directory into accelerometer and time data.
% Time data is offset from start_time, and dirname is the name of
% the directory to process.
%parpool(4);
listing = dir(dirname);
listing = listing(3:end);

%% Collect data from individual files
disp('Collecting data... ');
data_cells = {};
parfor i=1:length(listing)
    [accel, times] = import_file(strcat(dirname, '/', listing(i).name));
    data_cells{i} = {accel, times};
    disp(strcat('Finished ', listing(i).name));
end
save('cells.mat', 'data_cells')

%% Move data into one giant array
% Get total size to pre-allocate
% total_length = 0;
% for i=1:length(data_cells)
%     total_length = total_length + length(data_cells{i});
% end
% 
% for i=1:length(data_cells)
% end

end