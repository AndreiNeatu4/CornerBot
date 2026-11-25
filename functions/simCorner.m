function log = simCorner(ctrl, p, tEnd, tiltDeg, dist)
% Run a controller on the corner model.
% ctrl: @(obs) -> [pwmX pwmY pwmZ]. dist: [time Tx Ty Tz duration] rows (world).
if nargin < 5, dist = zeros(0,5); end
n = round(tEnd/p.dt);
s = cornerInit(tiltDeg, p);
log.t = (0:n-1)'*p.dt;
log.tilt = nan(n,1); log.obs = nan(n,10); log.u = nan(n,3); log.wheel = nan(n,3);
for k = 1:n
    t = log.t(k);
    on = t >= dist(:,1) & t < dist(:,1) + dist(:,5);
    Td = sum(dist(on, 2:4), 1)';
    if isempty(Td), Td = zeros(3,1); end
    u = ctrl(s.obs);
    s = cornerStep(s, u, p, Td);
    log.tilt(k) = s.tilt;
    log.obs(k,:) = s.obs;
    log.u(k,:) = u;
    log.wheel(k,:) = s.psid'*60/(2*pi);
    if s.fallen, break; end
end
log.tUp = k*p.dt;
log.fallen = s.fallen;
log.final = s;
end
