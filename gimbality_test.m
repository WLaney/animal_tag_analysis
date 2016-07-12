[ax,ay,az,~,~,~,dt,~,~] = import_tag_gyro2('tests/slow-pitch360.txt');

[ap, ar] = accel_pr(ax, ay, az);
% weird correction here
nap = ap<0;
ap(nap) = ap(nap) * -1;

nar = ar<0;
ar(nar) = ar(nar) * -1;

plot(dt, [ap, ar]);
legend('pitch', 'roll');
