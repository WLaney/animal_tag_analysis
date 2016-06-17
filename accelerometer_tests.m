disp 'When you''re ready to advance to the next test, hit the enter key.'
disp 'Test: wait'
run_accelerometer_test('wait');
pause
disp 'Test: pitch'
run_accelerometer_test('pitch');
pause
disp 'Test: roll'
run_accelerometer_test('roll');
pause
disp 'Test: roll180'
run_accelerometer_test('roll180');
pause
disp 'Test: roll360'
run_accelerometer_test('roll360');
pause
disp 'Test: yaw360'
run_accelerometer_test('yaw360');