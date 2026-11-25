function o = cornerObs(s, gyroZ)
% Firmware signals: [angX angY gXf gYf gyroZ speedX speedY accX accY speedZ].
ws = s.ws;
speedX = ((ws(3) - (ws(2) + ws(1))*0.5)*0.5)*1.81;
speedY = 0.866*(ws(2) - ws(1))/1.1;
o = [s.angX s.angY s.gXf s.gYf gyroZ speedX speedY s.accXs s.accYs sum(ws)];
end
