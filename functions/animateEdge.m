function animateEdge(ctrl, p, tEnd, tiltDeg, dist, speed)
% Watch a controller on the edge. speed: 1 = real time.
if nargin < 5, dist = zeros(0,3); end
if nargin < 6, speed = 1; end
s = edgeInit(tiltDeg, p);
n = round(tEnd/p.dt);
t0 = tic;
for k = 1:n
    t  = (k-1)*p.dt;
    Td = sum(dist(t >= dist(:,1) & t < dist(:,1) + dist(:,3), 2));
    u  = ctrl(s.obs);
    s  = edgeStep(s, u, p, Td);
    info.push = Td;
    info.text = sprintf("t = %.1f s   tilt = %+.2f°   PWM = %+4.0f", t, rad2deg(s.x(1)), u);
    edgeDraw(s, p, info);
    while toc(t0) < k*p.dt/speed, end
    if s.fallen, break; end
end
end
