function t = tiltOf(s)
% Angle between cube diagonal and vertical [deg].
dw = s.R*s.g.d;
t = acosd(min(1, dw(3)));
end
