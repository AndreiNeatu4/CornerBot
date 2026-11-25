function s = edgeStep(s, u, p, Tdist)
% One 15 ms control step, firmware order.
% obs = [angle deg, gyro deg/s, wheel counts/step, accumulated].
if nargin < 4, Tdist = 0; end
ws = s.obs(3);

% Firmware: accumulate after PWM, Motor3_control adds wheel speed
s.acc = s.acc + fix(ws/p.accDiv);
u = max(-p.pwmMax, min(p.pwmMax, u));
u = max(-p.pwmMax, min(p.pwmMax, u + ws));
h = p.dt/p.nSub;

% Physics, semi-implicit Euler
x = s.x;
for k = 1:p.nSub
    T  = motorModel(u, x(3), p);
    dx = edgeDynamics(x, T, p);
    dx(2) = dx(2) + Tdist/p.Ib;
    dx(3) = dx(3) - Tdist/p.Ib;
    x(2:3) = x(2:3) + h*dx(2:3);
    x([1 4]) = x([1 4]) + h*x([2 3]);
end
s.x = x;

% Sensors
gyro = rad2deg(x(2));
accA = rad2deg(x(1));
if p.noise
    gyro = gyro + p.gyroNoiseDps*randn;
    accA = accA + p.accNoiseDeg*randn;
end
gyro = round(gyro/p.gyroLsb)*p.gyroLsb;

% Firmware filters
s.angF  = complementaryFilter(s.angF, gyro, accA, p);
s.gyroF = p.alphaGyro*gyro + (1 - p.alphaGyro)*s.gyroF;

% Encoder
c  = round(x(4)*p.encCPR/(2*pi));
ws = c - s.counts;
s.counts = c;

s.obs = [s.angF s.gyroF ws s.acc];
s.fallen = abs(rad2deg(x(1))) > p.fallDeg;
end
