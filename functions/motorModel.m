function T = motorModel(u, w, p)
% PWM -> voltage -> torque, minus back-EMF.
V = p.Vbat*u/p.pwmMax;
T = p.Tstall*(V/p.Vnom - w/p.wNoLoad);
end
