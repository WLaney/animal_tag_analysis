% Convert txt files into matrices
fakef = fopen('model/fake.txt', 'r');
cells = textscan(fakef, '%s %s %f %f %f %f %f %f');
dts = strcat(cells{1}, '-', cells{2});
date_time = datetime(dts, 'InputFormat', 'M-d-y-H:m:s:SSSSSS');

fake_gyro  = [cells{3:5}];
fake_accel = [cells{6:8}];

realf = fopen('model/real.txt', 'r');
cells = textscan(realf, '%s %s %f %f %f %f %f %f');
% date_time should be the same for both
real_gyro  = [cells{3:5}];
real_accel = [cells{6:8}];

fclose(fakef);
fclose(realf);

save('model/sim.mat', 'date_time', 'fake_*', 'real_*');
