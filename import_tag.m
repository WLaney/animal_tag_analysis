function [accel,gyro,date_time,temp,pressure,date_time_short] = import_tag(filename, short)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   [accel,gyro,DATE_TIME,TEMP,PRESSURE] = import_tag(FILENAME, short)
%   Reads data from text file FILENAME for the default selection. Short is
%   an optional paramter that when set to true retuns temp, pressure, and
%   date_time called date_time_short without blank rows. The default value
%   of short is false

%% Initialize variables.
startRow = 2;
endRow = inf;
if nargin < 2 %check if short info was provided, if it was not make it false
    short=false;
end

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%4s%5s%5s%5s%5s%5s%18s%6s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    for col=1:length(dataArray)
        dataArray{col} = [dataArray{col};dataArrayBlock{col}];
    end
end

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2,3,4,5,6,8,9]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

% Convert the contents of columns with dates to MATLAB datetimes using date
% format string.
try
    dates{7} = datetime(dataArray{7}, 'Format', 'y-M-d H:m:s', 'InputFormat', 'y-M-d H:m:s');
catch
    try
        % Handle dates surrounded by quotes
        dataArray{7} = cellfun(@(x) x(2:end-1), dataArray{7}, 'UniformOutput', false);
        dates{7} = datetime(dataArray{7}, 'Format', 'y-M-d H:m:s', 'InputFormat', 'y-M-d H:m:s');
    catch
        dates{7} = repmat(datetime([NaN NaN NaN]), size(dataArray{7}));
    end
end

anyBlankDates = cellfun(@isempty, dataArray{7});
anyInvalidDates = isnan(dates{7}.Hour) - anyBlankDates;
dates = dates(:,7);

%% Split data into numeric and cell columns.
rawNumericColumns = raw(:, [1,2,3,4,5,6,8,9]);

%% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
rawNumericColumns(R) = {NaN}; % Replace non-numeric cells

%% Allocate imported array to column variable names
ax = cell2mat(rawNumericColumns(:, 1));
ay = cell2mat(rawNumericColumns(:, 2));
az = cell2mat(rawNumericColumns(:, 3));
gx = cell2mat(rawNumericColumns(:, 4));
gy = cell2mat(rawNumericColumns(:, 5));
gz = cell2mat(rawNumericColumns(:, 6));
date_time = dates{:, 1};
temp = cell2mat(rawNumericColumns(:, 7));
pressure = cell2mat(rawNumericColumns(:, 8));

%consolidate accel and gyro in to 2 matricies
accel=[ax, ay, az];
gyro=[gx, gy, gz];
clear ax ay az gx gy gz %clear repative variables to free up space

%% creat short versions, if needed
%if short is requested creat the short time, pressure, and temp
if short==true
    %creat date_time file of only datetimes written by RTC with no blanks
    %for the pressure/temp data
    date_time_short=date_time(~isnat(date_time));
    %the first row does not have a coroponding temp/pressure
    date_time_short(1)=[];
    
    %get rid of all blank rows in pressure and temp
    not_data=isnan(temp(1:end));
    temp(not_data,:)=[];
    pressure(not_data,:)=[];
else
    date_time_short=[];
end

%% Datetime interpolation
%interpolate the data time between RTC writes
inds = find(~isnat(date_time));
% from 1 to (inds-1):
%   get the last time value and the current one
%   find the number of indices between the two
%   linspace() the two and assign it to the date_time
for n=1:(length(inds)-1)
    i_old = inds(n);
    i_new = inds(n+1);
    t_old = date_time(i_old);
    t_new = date_time(i_new);
    date_time(i_old:(i_new-1)) = linspace(t_old, t_new, i_new-i_old);
end

%interpreter doent work with only one time stamp so data at the very end of
%the file can't be interperpolated. This is not much
%data so we are just going to remove it
data_end=isnat(date_time); %find uninterpolated data

%we should not have to remove very many data points, if we do there is
%probably a problem with the data
max_data_removal= 150; %the max amount of data that is safe to remove
if length(data_end) > max_data_removal
    warning(['There is more data without a closing time'...
    ' then expected. Please double check the datafile for problems'])
end

date_time(data_end)=[]; %remove data
accel(data_end,:)=[];
gyro(data_end,:)=[];

%% Remove Blank Rows

%get rid off all bank rows in accel and gyro
not_data=isnan(accel(:,1));
accel(not_data,:)=[];
gyro(not_data,:)=[];

%remove unneeded time stamps, this makes accel/gyro the same length as
%date_time. The removed times corosponed to when the RTC wrote the time to
%the SD, this does not occure simotanusly with any accel/gyro read
date_time(not_data)=[];
end
