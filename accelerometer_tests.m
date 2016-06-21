disp 'Press enter to continue.';

test_folders = dir('model/tests');
for test=3:length(test_folders)
	run_accelerometer_test(test_folders(test).name);
	pause
	close all
end
