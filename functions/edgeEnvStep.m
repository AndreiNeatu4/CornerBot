function [obs, R, done, ls] = edgeEnvStep(a, ls, p, r)
% Action in [-1 1] -> PWM.
a = max(-1, min(1, a(1)));
ls.s = edgeStep(ls.s, a*p.pwmMax, p);
ls.k = ls.k + 1;

o   = ls.s.obs./r.obsScale;
obs = max(-5, min(5, o))';
R   = rewardFcn(rad2deg(ls.s.x(1)), a, o(3), ls.s.fallen, r);
done = ls.s.fallen || ls.k >= r.maxSteps;
end
