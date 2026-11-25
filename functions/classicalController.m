function u = classicalController(obs, K, p)
% Firmware law: u = K1*angle + K2*gyro + K3*wheelSpeed + K4*accWheelSpeed.
u = K(1)*obs(1) + K(2)*obs(2) + K(3)*obs(3) + K(4)*obs(4);
u = max(-p.pwmMax, min(p.pwmMax, u));
end
