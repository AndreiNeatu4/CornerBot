function [obs, ls] = cornerEnvReset(p, r)
% Random start tilt, cube and pushes.
persistent ep
if isempty(ep), ep = 0; end
ep = ep + 1;
if isfield(r, "allPositions") && r.allPositions, p.cornerV = randi([0 1], 1, 3); end
if r.randomize
    p = randomizeParams(p);
    p.comAxis = p.comAxis*(1 + 0.05*(2*rand - 1));
end
ls.p = p;
ls.s = cornerInit((2*rand(1,2) - 1)*r.initTilt, p);
ls.k = 0;
ls.ep = ep;
ls.render = r.renderEvery > 0 && mod(ep, r.renderEvery) == 1;
n = randi([0 r.nPush]);
ls.pushK = sort(randi([100 r.maxSteps - 100], 1, n));
dir = rand(1, n)*2*pi;
ls.pushT = [cos(dir); sin(dir); zeros(1, n)].*(rand(1, n)*r.pushMax);
obs = (ls.s.obs./r.obsScale)';
end
