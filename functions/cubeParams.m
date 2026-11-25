function p = cubeParams()
% Cube, motor and firmware parameters. Estimates until measured.

p.g = 9.81;

% Cube
p.a  = 0.15;              % side [m]
p.m  = 0.80;              % total mass [kg]
p.l  = p.a/sqrt(2);       % edge to COM [m]
p.Ib = 2/3*p.m*p.a^2;     % inertia about edge [kg m^2]
p.cb = 1e-4;              % pivot friction [N m s]

% Wheel
p.mw = 0.08;              % [kg]
p.rw = 0.04;              % [m]
p.Iw = 0.7*p.mw*p.rw^2;   % rim-weighted disc [kg m^2]
p.cw = 2e-5;              % bearing friction [N m s]

% Motor (Nidec 24H)
p.Vnom    = 12;           % [V]
p.Tstall  = 0.05;         % at Vnom [N m]
p.wNoLoad = 400;          % at Vnom [rad/s]
p.Vbat    = 11.1;         % 3S [V]
p.encCPR  = 200;          % counts/rev

% Firmware
p.dt        = 0.015;      % control step [s]
p.nSub      = 15;         % physics substeps
p.pwmMax    = 255;
p.alphaComp = 0.996;
p.alphaGyro = 0.7;
p.fallDeg   = 7;
p.edgeGains   = [190 31 2.5 0.014];
p.cornerGains = [180 30 1.6 0.008];
p.yawGains    = [8 0.3];

% Sensors
p.accNoiseDeg  = 0.3;     % std [deg]
p.gyroNoiseDps = 0.05;    % std [deg/s]
p.gyroLsb      = 1/131;   % [deg/s]
p.noise        = true;
end
