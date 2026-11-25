function res = evaluate(ctrl, p, name)
% Shared test for any edge controller. ctrl: @(obs) -> PWM.
% 20 starts up to +/-3 deg, 10 pushes of growing size.
if nargin < 2, p = cubeParams(); end
if nargin < 3, name = "controller"; end
tEnd = 30;

% Starts
rng(0);
th0 = 3*(2*rand(20,1) - 1);
tUp = zeros(20,1); tilt = nan(20,1); eff = nan(20,1);
for i = 1:20
    L = simEdge(ctrl, p, tEnd, th0(i));
    tUp(i) = L.tUp;
    tilt(i) = mean(abs(L.tilt), "omitnan");
    eff(i) = mean(abs(L.u), "omitnan");
end

% Pushes, 50 ms, alternating sign
Tp = linspace(0.01, 0.1, 10)'.*(-1).^(0:9)';
pushOk = false(10,1); pushMax = nan(10,1);
for i = 1:10
    rng(i);
    L = simEdge(ctrl, p, 10, 0, [3 Tp(i) 0.05]);
    pushOk(i) = ~L.fallen;
    pushMax(i) = max(abs(L.tilt));
end

res.name     = string(name);
res.th0      = th0;
res.tUp      = tUp;
res.meanTUp  = mean(tUp);
res.upright  = sum(tUp >= tEnd);
res.meanTilt = mean(tilt, "omitnan");
res.effort   = mean(eff, "omitnan");
res.pushT    = Tp;
res.pushOk   = pushOk;
res.pushMax  = pushMax;
res.pushes   = sum(pushOk);
res.pass = res.meanTUp >= tEnd && res.meanTilt < 1 && res.pushes >= 8;
end
