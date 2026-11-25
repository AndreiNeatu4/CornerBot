function p = cubeParams()
% Cube, motor and firmware parameters.
% Sources: remrc STL files (thing:6695891), remrc firmware esp32_cube_enc.
% (est) = estimate, replace with measurement.

p.g = 9.81;

% Printed parts: PLA, 50-60% infill
rhoPLA = 1240*0.75;                 % effective [kg/m^3] (est)
vFrame = (24.64 + 1.29 + 5.81 + 6.51 + 16.29 + 1.23 + 41.33 ...
          + 104.3 + 86.2)*1e-6;     % all but wheels, from STL [m^3]
vWheel = 24.2e-6;                   % one wheel, from STL [m^3]

% Wheel (x3)
p.rimMass = 32*0.0025;              % 32 x M4x10 flat head + nut per wheel (video)
p.rimR    = 0.0575;                 % rim hole radius, from STL [m]
p.mw = rhoPLA*vWheel + p.rimMass;   % [kg]
p.Iw = rhoPLA*vWheel*2165e-6 + p.rimMass*p.rimR^2; % STL: I/m = 2165 mm^2
p.cw = 2e-5;                        % bearing friction [N m s] (est)

% Cube
p.a  = 0.152;                       % side, from STL [m]
mMotor = 0.100;                     % Nidec 24H (est)
mBatt  = 0.045;                     % 3S 500 mAh (est)
mElec  = 0.070;                     % ESP32, wiring, screws (est)
p.m  = rhoPLA*vFrame + 3*p.mw + 3*mMotor + mBatt + mElec;

% COM: wheels and motors sit near the faces at corner A (video)
zW = 0.020; zM = 0.045;             % wheel / motor depth from face (est)
mSet = p.mw + mMotor;
p.comAxis = ((p.m - 3*mSet)*p.a/2 + 2*mSet*p.a/2 + p.mw*zW + mMotor*zM)/p.m;
p.kIc = 0.22;                       % body inertia about COM / (m a^2) (est)
p.l  = sqrt(2)*p.comAxis;           % edge to COM [m]
p.Ib = p.kIc*p.m*p.a^2 + p.m*p.l^2; % about edge
p.cb = 1e-4;                        % pivot friction [N m s] (est)
p.comOffset = 0;                    % COM vs calibrated balance [rad]

% Motor (Nidec 24H)
p.Vnom    = 12;                     % [V]
p.Tstall  = 0.05;                   % at Vnom [N m] (est)
p.wNoLoad = 3020*2*pi/60;           % at Vnom, seller data [rad/s]
p.Vbat    = 11.1;                   % 3S [V]
p.encCPR  = 400;                    % 100 lines x4, seller data

% Firmware
p.dt        = 0.015;                % loop_time [s]
p.nSub      = 15;                   % physics substeps
p.pwmMax    = 255;
p.alphaComp = 0.996;                % Gyro_amount
p.alphaGyro = 0.7;                  % alpha
p.gyroIntScale = 131/65.536;        % angle_calc uses /65.536, range is 131 LSB
p.accDiv    = 5;                    % motors_speed += speed/5
p.fallDeg   = 7;
p.edgeGains   = [190 31 2.5 0.014];
p.cornerGains = [180 30 1.6 0.008];
p.yawGains    = [8 0.3];

% Corner conventions (see cornerGeom)
p.sigX   = 1;                       % sensor x along +/- wheel 3 projection
p.sigW   = 1;                       % motor positive direction
p.swap12 = false;                   % motor 1 / 2 on body axes 2 / 1
p.corner = 1;                       % 1 = corner A (remrc), 2 = opposite corner B

% Sensors
p.accNoiseDeg  = 0.3;               % std [deg] (est)
p.gyroNoiseDps = 0.05;              % std [deg/s] (est)
p.gyroLsb      = 1/131;             % [deg/s]
p.noise        = true;
end
