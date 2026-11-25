function r = rlParams()
% RL settings for the edge.
r.maxSteps  = 2000;                 % 30 s
r.initTilt  = 0.5;                  % reset tilt range, +/- [deg]
r.obsScale  = [7 100 300 2000];     % angle, gyro, wheel, accumulated
r.a = 0.1;                          % tilt^2 [deg]
r.b = 0.2;                          % u^2, u in [-1 1]
r.c = 0.05;                         % wheel^2, scaled
r.fallPenalty = 100;
r.randomize = true;                 % new cube each episode
r.nPush     = 0;                    % max pushes per episode
r.pushMax   = 0.06;                 % [N m]
r.pushSteps = 3;                    % 45 ms
r.renderEvery = 0;                  % draw every Nth episode, 0 = off
end
