function ang = complementaryFilter(angPrev, gyroDps, accDeg, p)
% Same as firmware, including its gyro scale.
ang = p.alphaComp*(angPrev + p.gyroIntScale*gyroDps*p.dt) + (1 - p.alphaComp)*accDeg;
end
