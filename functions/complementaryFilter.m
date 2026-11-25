function ang = complementaryFilter(angPrev, gyroDps, accDeg, p)
% Same as firmware.
ang = p.alphaComp*(angPrev + gyroDps*p.dt) + (1 - p.alphaComp)*accDeg;
end
