function [obs, R, done, ls] = cornerEnvStep(a, ls, ~, r)
% Actions in [-1 1] -> PWM X, Y, Z.
p = ls.p;
a = max(-1, min(1, a(:)'));
on = ls.k >= ls.pushK & ls.k < ls.pushK + r.pushSteps;
Td = sum(ls.pushT(:, on), 2);
ls.s = cornerStep(ls.s, a*p.pwmMax, p, Td);
ls.k = ls.k + 1;

o   = ls.s.obs./r.obsScale;
obs = max(-5, min(5, o))';
if ls.s.fallen
    R = -r.fallPenalty;
else
    R = 1 - r.a*ls.s.tilt^2 - r.b*mean(a.^2) - r.c*mean(o([6 7 10]).^2);
end
done = ls.s.fallen || ls.k >= r.maxSteps;

if ls.render && (mod(ls.k, 2) == 0 || done)
    info.push = Td;
    info.text = sprintf("Episode %d   t = %.1f s   tilt = %.2f°   PWM = %+4.0f %+4.0f %+4.0f", ...
        ls.ep, ls.k*p.dt, ls.s.tilt, a*p.pwmMax);
    cornerDraw(ls.s, p, info);
end
end
