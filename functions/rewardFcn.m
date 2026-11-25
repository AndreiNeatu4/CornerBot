function R = rewardFcn(tiltDeg, u, wheelScaled, fallen, r)
% +1 per step - a*tilt^2 - b*u^2 - c*wheel^2, fall penalty.
if fallen
    R = -r.fallPenalty;
else
    R = 1 - r.a*tiltDeg^2 - r.b*u^2 - r.c*wheelScaled^2;
end
end
