function [obs, R, done, ls] = edgeEnvStep(a, ls, ~, r)
% Action in [-1 1] -> PWM.
p = ls.p;
a = max(-1, min(1, a(1)));
on = ls.k >= ls.pushK & ls.k < ls.pushK + r.pushSteps;
Td = sum(ls.pushT(on));
ls.s = edgeStep(ls.s, a*p.pwmMax, p, Td);
ls.k = ls.k + 1;

o   = ls.s.obs./r.obsScale;
obs = max(-5, min(5, o))';
R   = rewardFcn(rad2deg(ls.s.x(1)), a, o(3), ls.s.fallen, r);
done = ls.s.fallen || ls.k >= r.maxSteps;

if ls.render && (mod(ls.k, 2) == 0 || done)
    info.push = Td;
    info.text = sprintf("Episode %d   t = %.1f s   tilt = %+.2f°   PWM = %+4.0f", ...
        ls.ep, ls.k*p.dt, rad2deg(ls.s.x(1)), a*p.pwmMax);
    edgeDraw(ls.s, p, info);
end
end
