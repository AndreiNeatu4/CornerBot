function p = edgeGeom(p, offs)
% Edge model params for any edge. offs: [0/1 0/1], the edge's two fixed
% coordinates (0 = side of corner A). Edge axis is irrelevant (COM symmetric).
o = abs(p.comAxis - p.a*offs(:));
p.l  = norm(o);
p.Ib = p.kIc*p.m*p.a^2 + p.m*p.l^2;
p.edgeOffs = offs;
end
