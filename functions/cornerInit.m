function s = cornerInit(tiltDeg, p)
% Initial state. tiltDeg = [about world x, about world y].
if isscalar(tiltDeg), tiltDeg = [tiltDeg 0]; end
g = cornerGeom(p);
t = deg2rad(tiltDeg);
Rx = [1 0 0; 0 cos(t(1)) -sin(t(1)); 0 sin(t(1)) cos(t(1))];
Ry = [cos(t(2)) 0 sin(t(2)); 0 1 0; -sin(t(2)) 0 cos(t(2))];
s.g = g;
s.R = Ry*Rx*g.R0;
s.w = zeros(3,1);
s.psid = zeros(3,1);
s.psi  = zeros(3,1);
[accX, accY] = accAngles(s.R, g, p);
s.angX = accX; s.angY = accY;
s.gXf = 0; s.gYf = 0;
s.counts = zeros(3,1);
s.ws  = zeros(3,1);
s.accXs = 0; s.accYs = 0;
s.obs = cornerObs(s, 0);
s.tilt = tiltOf(s);
s.fallen = s.tilt > p.fallDeg;
end
