function r = rlParams()
% RL settings for the edge.
r.maxSteps  = 2000;                 % 30 s
r.initTilt  = 0.5;                  % reset tilt range, +/- [deg]
r.obsScale  = [7 100 300 2000];     % angle, gyro, wheel, accumulated
r.a = 0.1;                          % tilt^2 [deg]
r.b = 0.05;                         % u^2, u in [-1 1]
r.c = 0.05;                         % wheel^2, scaled
r.fallPenalty = 100;
end
