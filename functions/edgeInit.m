function s = edgeInit(tiltDeg, p)
% Initial state; filter starts at true angle.
s.x      = [deg2rad(tiltDeg); 0; 0; 0];
s.angF   = tiltDeg;
s.gyroF  = 0;
s.counts = 0;
s.acc    = 0;
s.obs    = [tiltDeg 0 0 0];
s.fallen = abs(tiltDeg) > p.fallDeg;
end
