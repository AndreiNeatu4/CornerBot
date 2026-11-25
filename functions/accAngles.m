function [angX, angY, f] = accAngles(R, g, p, noise)
% Firmware accelerometer angles [deg]. f: specific force in sensor frame [g].
% Corner A: remrc formulas. Corner B (sensor upside down): AcZ sign flipped.
if nargin < 4, noise = 0; end
f = g.S'*(R'*[0; 0; 1]);
f = f + noise*randn(3,1);
if g.corner == 1
    angY =  atan2d(f(1), -f(3));
    angX = -atan2d(f(2), -f(3));
else
    angY = -atan2d(f(1), f(3));
    angX =  atan2d(f(2), f(3));
end
end
