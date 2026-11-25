function s = cornerStep(s, pwm, p, Td)
% One 15 ms step on the corner. pwm = [pwmX pwmY pwmZ] before mixing.
if nargin < 4, Td = zeros(3,1); end
g = s.g;
c = @(v) max(-p.pwmMax, min(p.pwmMax, v));
pwm = c(pwm(:)');

% Firmware: accumulate after PWM, then XYZ_to_threeWay(-X, Y, -Z)
o = s.obs;
s.accXs = s.accXs + fix(o(6)/p.accDiv);
s.accYs = s.accYs + fix(o(7)/p.accDiv);
X = -pwm(1); Y = pwm(2); Z = -pwm(3);
m = [round((0.5*X - 0.866*Y)/1.37 + Z);
     round((0.5*X + 0.866*Y)/1.37 + Z);
     fix(-X/1.37 + Z)];
u = c(m + s.ws);                           % MotorN_control adds own speed

% Physics, semi-implicit Euler
h = p.dt/p.nSub;
R = s.R; w = s.w; psid = s.psid; psi = s.psi;
for k = 1:p.nSub
    T = motorModel(u, psid, p);
    [wd, psidd] = cornerDynamics(R, w, psid, T, g, p, Td);
    w = w + h*wd;
    psid = psid + h*psidd;
    psi = psi + h*psid;
    W = [0 -w(3) w(2); w(3) 0 -w(1); -w(2) w(1) 0];
    R = R*expm3(h*W);
end
[U, ~, V] = svd(R); s.R = U*V';
s.w = w; s.psid = psid; s.psi = psi;

% Sensors
gyro = rad2deg(g.S'*w);
nA = 0;
if p.noise
    gyro = gyro + p.gyroNoiseDps*randn(3,1);
    nA = deg2rad(p.accNoiseDeg);
end
gyro = round(gyro/p.gyroLsb)*p.gyroLsb;
[aX, aY] = accAngles(s.R, g, p, nA);

% Firmware filters
s.angX = p.alphaComp*(s.angX + p.gyroIntScale*gyro(1)*p.dt) + (1 - p.alphaComp)*aX;
s.angY = p.alphaComp*(s.angY + p.gyroIntScale*gyro(2)*p.dt) + (1 - p.alphaComp)*aY;
s.gXf = p.alphaGyro*gyro(1) + (1 - p.alphaGyro)*s.gXf;
s.gYf = p.alphaGyro*gyro(2) + (1 - p.alphaGyro)*s.gYf;

% Encoders
cnt = round(psi*p.encCPR/(2*pi));
s.ws = cnt - s.counts;
s.counts = cnt;

s.obs = cornerObs(s, gyro(3));
s.tilt = tiltOf(s);
s.fallen = s.tilt > p.fallDeg;
end

function E = expm3(W)
% Rotation from skew matrix (Rodrigues).
th = norm([W(3,2) W(1,3) W(2,1)]);
if th < 1e-12, E = eye(3) + W; return; end
E = eye(3) + sin(th)/th*W + (1 - cos(th))/th^2*(W*W);
end
