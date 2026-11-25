function [obs, ls] = edgeEnvReset(p, r)
% Random start tilt, cube and pushes.
if r.randomize, p = randomizeParams(p); end
ls.p = p;
ls.s = edgeInit((2*rand - 1)*r.initTilt, p);
ls.k = 0;
n = randi([0 r.nPush]);
ls.pushK = sort(randi([100 r.maxSteps - 100], 1, n));
ls.pushT = (2*rand(1, n) - 1)*r.pushMax;
obs = (ls.s.obs./r.obsScale)';
end
