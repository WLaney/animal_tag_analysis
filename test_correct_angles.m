[~,~,~,~,gy,~,~,~,~] = import_tag_gyro2('tests/roll180.txt');
gr_reg = cumsum(gy ./ 12);
gr_loop = (mod(gr_reg+180, 360) - 180);
gr_unloop = unwrap_angles(gr_loop);

eq = (abs(gr_reg - gr_unloop) > 0.0000001);

disp('Mismatches:');
disp(sum(eq));

i = 1:size(gr_reg);
hold on
plot(i, [gr_reg, gr_loop, gr_unloop]);
legend('Regular', 'Looped', 'Unlooped');
for j=1:size(eq)
    if eq(j)
       plot([j,j], [0,100], ':r'); 
    end
end
hold off