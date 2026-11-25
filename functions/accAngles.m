function [angX, angY, f] = accAngles(R, g, p, noise)
% Firmware accelerometer angles [deg] from virtual sensor. f: specific force [g].
% Corner A formulas; legacy corner B: AcZ sign flipped.
if nargin < 4, noise = 0; end
f = g.S'*(R'*[0; 0; 1]) + noise*randn(3,1);
f = g.Qs*f;
if isfield(g, "accOff"), f = f - g.accOff; end
if g.corner == 1
    angY =  atan2d(f(1), -f(3));
    angX = -atan2d(f(2), -f(3));
else
    angY = -atan2d(f(1), f(3));
    angX =  atan2d(f(2), f(3));
end
end
