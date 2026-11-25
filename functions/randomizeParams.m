function p = randomizeParams(p)
% Random cube for one episode (domain randomization).
U = @(a, b) a + (b - a)*rand;
p.Iw      = p.Iw*U(0.7, 1.3);
k         = U(0.9, 1.1);
p.m       = p.m*k;
p.Ib      = p.Ib*k*U(0.9, 1.1);
p.l       = p.l*U(0.95, 1.05);
p.Tstall  = p.Tstall*U(0.6, 1.6);
p.wNoLoad = p.wNoLoad*U(0.9, 1.1);
p.Vbat    = U(10.8, 12.6);
p.cw      = p.cw*U(0.5, 2);
p.cb      = p.cb*U(0.5, 2);
p.accNoiseDeg  = p.accNoiseDeg*U(0.5, 2);
p.gyroNoiseDps = p.gyroNoiseDps*U(0.5, 2);
p.comOffset    = deg2rad(U(-0.3, 0.3));   % calibration error
end
