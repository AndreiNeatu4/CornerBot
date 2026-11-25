function ctrl = agentController(agent, p, r)
% Agent as a controller: firmware obs -> PWM.
ctrl = @(o) act(agent, o, p, r);
end

function u = act(agent, o, p, r)
a = getAction(agent, {max(-5, min(5, o./r.obsScale))'});
u = double(a{1})*p.pwmMax;
end
