function g = cornerGeom(p)
% Corner geometry. Body frame: corner A, axes along the 3 cube edges.
% Wheel i spins about body axis i. Sensor z points from B to A.
% p.cornerV (any corner, [0/1 0/1 0/1]): pivot at a*cornerV, sensors and motors
%   mapped through Q to the frame of corner A, so one controller fits all.
% Legacy: p.corner = 1 (A) or 2 (B, own angle formulas).
a = p.a;
I3 = eye(3);
c = p.comAxis*[1; 1; 1];
if isfield(p, "cornerV")
    g.pivot = a*p.cornerV(:);
    g.r = c - g.pivot;
    Q = diag(sign(g.r));
    if det(Q) < 0, Q = I3([2 1 3], :)*Q; end
    g.Q = Q;                               % body -> canonical (corner A)
    g.corner = 1;
else
    g.pivot = (p.corner == 2)*a*[1; 1; 1];
    g.r = c - g.pivot;
    g.Q = I3;
    g.corner = p.corner;
end
g.d  = g.r/norm(g.r);                      % up when balanced
g.Ib = p.kIc*p.m*a^2*I3 + p.m*(g.r'*g.r*I3 - g.r*g.r');  % without wheel spin
g.IbInv = inv(g.Ib);

% Sensor axes in body frame (columns): x along wheel 3 projection
zs = -[1; 1; 1]/sqrt(3);
xs = p.sigX*[-1; -1; 2]/sqrt(6);
ys = cross(zs, xs);
g.S = [xs ys zs];

% Motor i -> body axis, with sign
if p.swap12, g.W = I3(:, [2 1 3]); else, g.W = I3; end
g.W = p.sigW*g.W;

% Virtual sensor and motor maps
g.Qs = g.S'*g.Q*g.S;                       % physical sensor -> virtual sensor
g.Qm = g.W'*g.Q*g.W;                       % physical motor -> virtual motor

% Balanced orientation: diagonal to world z
ax = cross(g.d, [0; 0; 1]);
if norm(ax) < 1e-9, g.R0 = I3; else, g.R0 = axang(ax/norm(ax), acos(g.d(3))); end

% Calibration (c+/c-): accel X, Y offsets at the balance point
f0 = g.Qs*(g.S'*(g.R0'*[0; 0; 1]));
g.accOff = [f0(1:2); 0];
end

function R = axang(u, t)
K = [0 -u(3) u(2); u(3) 0 -u(1); -u(2) u(1) 0];
R = eye(3) + sin(t)*K + (1 - cos(t))*K*K;
end
