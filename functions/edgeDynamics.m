function dx = edgeDynamics(x, T, p)
% x = [tilt; tiltRate; wheelSpeed; wheelAngle], wheel relative to body.
th = x(1); thd = x(2); wd = x(3);
thdd = (p.m*p.g*p.l*sin(th - p.comOffset) - T + p.cw*wd - p.cb*thd)/p.Ib;
wdd  = (T - p.cw*wd)/p.Iw - thdd;
dx = [thd; thdd; wdd; wd];
end
