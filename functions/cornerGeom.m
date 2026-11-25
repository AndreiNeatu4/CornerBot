function g = cornerGeom(p)
% Corner geometry. Body frame: pivot corner, axes along the 3 cube edges.
% Wheel i spins about body axis i. Sensor z points down the diagonal.
a = p.a;
g.r  = a/2*[1; 1; 1];                      % pivot to COM
g.d  = [1; 1; 1]/sqrt(3);                  % diagonal, up when balanced
I3 = eye(3);
k = p.Ib/(p.m*a^2) - 0.5;                  % same body inertia as edge model
g.Ib = k*p.m*a^2*I3 + p.m*(g.r'*g.r*I3 - g.r*g.r');  % without wheel spin
g.IbInv = inv(g.Ib);

% Sensor axes in body frame (columns): x along wheel 3 projection
zs = -g.d;
xs = p.sigX*[-1; -1; 2]/sqrt(6);
ys = cross(zs, xs);
g.S = [xs ys zs];

% Motor i -> body axis, with sign
if p.swap12, g.W = I3(:, [2 1 3]); else, g.W = I3; end
g.W = p.sigW*g.W;

% Balanced orientation: diagonal to world z
ax = cross(g.d, [0; 0; 1]);
g.R0 = axang(ax/norm(ax), acos(g.d(3)));
end

function R = axang(u, t)
K = [0 -u(3) u(2); u(3) 0 -u(1); -u(2) u(1) 0];
R = eye(3) + sin(t)*K + (1 - cos(t))*K*K;
end
