function animateCorner(ctrl, p, tEnd, tiltDeg, dist, speed)
% Watch a controller on the corner. dist: [time Tx Ty Tz duration] (world). speed: 1 = real time.
if nargin < 5, dist = zeros(0,5); end
if nargin < 6, speed = 1; end
s = cornerInit(tiltDeg, p);
n = round(tEnd/p.dt);
t0 = tic;
for k = 1:n
    t  = (k-1)*p.dt;
    on = t >= dist(:,1) & t < dist(:,1) + dist(:,5);
    Td = sum(dist(on, 2:4), 1)';
    if isempty(Td), Td = zeros(3,1); end
    u  = ctrl(s.obs);
    s  = cornerStep(s, u, p, Td);
    info.push = Td;
    info.text = sprintf("t = %.1f s   tilt = %.2f°   PWM X/Y/Z = %+4.0f %+4.0f %+4.0f", t, s.tilt, u);
    cornerDraw(s, p, info);
    while toc(t0) < k*p.dt/speed, end
    if s.fallen, break; end
end
end
