function [obs, R, done, ls] = edgeEnvStep(a, ls, ~, r)
% Action in [-1 1] -> PWM.
p = ls.p;
a = max(-1, min(1, a(1)));
on = ls.k >= ls.pushK & ls.k < ls.pushK + r.pushSteps;
ls.s = edgeStep(ls.s, a*p.pwmMax, p, sum(ls.pushT(on)));
ls.k = ls.k + 1;

o   = ls.s.obs./r.obsScale;
obs = max(-5, min(5, o))';
R   = rewardFcn(rad2deg(ls.s.x(1)), a, o(3), ls.s.fallen, r);
done = ls.s.fallen || ls.k >= r.maxSteps;
end
