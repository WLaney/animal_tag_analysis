function [depth]=pressure2depth(pressure_mbar)
%converts pressure in mbar to depth in m
%in feture factor in temp for more accurate messurment

%% Constants
%atmospheric pressure at Wachapreague, VA today (Jul 12, 2016)
p_atmosphere_in=30.1; %inHG

%approx density of brachis water, note density changes with depth but we
%probably don't need to account for that. Also changes with temp, can
%account for that when we integrate temp
rho=1.02; %kg/l = g/m^3

g=9.8; %gravity m/s^2
in2pa=3386.39; %1inHG = 3386.39pa
mbar2pa=100; %1mbar=100pa;

%% conversions
%get everything into SI units
p_atmosphere=p_atmosphere_in*in2pa;
pressure=pressure_mbar*mbar2pa;

%% calulate depth
%P_fluid=rho*g*depth
%P_total=P_fluid+P_atmosphere
%therfore; depth=(P_total-P_atmosphere)/(rho*g)
depth=(pressure-p_atmosphere)./(rho*g);
end