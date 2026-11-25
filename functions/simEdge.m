function log = simEdge(ctrl, p, tEnd, tiltDeg, dist)
% Run a controller on the edge model.
% ctrl: @(obs) -> PWM. dist: [time torque duration] rows, optional.
if nargin < 5, dist = zeros(0,3); end
n = round(tEnd/p.dt);
s = edgeInit(tiltDeg, p);

log.t    = (0:n-1)'*p.dt;
log.tilt = nan(n,1); log.obs = nan(n,4); log.u = nan(n,1); log.wheel = nan(n,1);
for k = 1:n
    u  = ctrl(s.obs);
    t  = log.t(k);
    Td = sum(dist(t >= dist(:,1) & t < dist(:,1) + dist(:,3), 2));
    s  = edgeStep(s, u, p, Td);
    log.tilt(k) = rad2deg(s.x(1));
    log.obs(k,:) = s.obs;
    log.u(k) = u;
    log.wheel(k) = s.x(3)*60/(2*pi);
    if s.fallen, break; end
end
log.tUp = k*p.dt;
log.fallen = s.fallen;
end
