function [obs, ls] = edgeEnvReset(p, r)
% Random start tilt.
ls.s = edgeInit((2*rand - 1)*r.initTilt, p);
ls.k = 0;
obs = (ls.s.obs./r.obsScale)';
end
