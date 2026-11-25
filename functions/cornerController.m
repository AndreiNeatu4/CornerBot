function pwm = cornerController(o, p)
% Firmware vertex law. o from cornerObs.
K = p.cornerGains; zK = p.yawGains;
c = @(v) max(-p.pwmMax, min(p.pwmMax, v));
pwm = [c(K(1)*o(1) + K(2)*o(3) + K(3)*o(6) + K(4)*o(8)), ...
       c(K(1)*o(2) + K(2)*o(4) + K(3)*o(7) + K(4)*o(9)), ...
       c(zK(1)*o(5) + zK(2)*o(10))];
end
