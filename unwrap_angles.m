function aout = unwrap_angles( ain )
% Represent a column vector of angles (in degrees) such that each angle
% has the smallest absolute difference from its predecessor.
%
% In other words, vectors like [0,179,-180,-179,-178] become
% [0,179,179,181,182]. This is useful for functions that treat their
% inputs as regular vectors, not angles. There are probably more
% elegant solutions to these sorts of problems, but screw that noise.

a2 = [0; ain(1:end-1)];
d = mod(ain - a2 + 180, 360) - 180;
aout = cumsum(d);

end