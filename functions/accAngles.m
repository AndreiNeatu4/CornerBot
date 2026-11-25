function [angX, angY, f] = accAngles(R, g, p, noise)
% Firmware accelerometer angles [deg]. f: specific force in sensor frame [g].
if nargin < 4, noise = 0; end
f = g.S'*(R'*[0; 0; 1]);
f = f + noise*randn(3,1);
angY =  atan2d(f(1), -f(3));
angX = -atan2d(f(2), -f(3));
end
