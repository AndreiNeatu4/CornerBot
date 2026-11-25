function [wd, psidd] = cornerDynamics(R, w, psid, T, g, p, Td)
% Body angular accel and wheel accel (motor coords).
% R body->world, w body rate, psid wheel speeds rel. to body, T motor torques.
wb  = g.W*psid;                            % wheel speeds along body axes
Tb  = g.W*T;
gb  = R'*[0; 0; -p.g];
L   = (g.Ib + p.Iw*eye(3))*w + p.Iw*wb;
tau = -cross(w, L) + cross(g.r, p.m*gb) - Tb + p.cw*wb - p.cb*w + R'*Td;
wd  = g.IbInv*tau;
wbd = (Tb - p.cw*wb)/p.Iw - wd;
psidd = g.W'*wbd;
end
