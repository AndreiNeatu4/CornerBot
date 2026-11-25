function env = createEdgeEnv(p, r)
% rlFunctionEnv around the edge model.
obsInfo = rlNumericSpec([4 1]);
obsInfo.Name = "obs";
actInfo = rlNumericSpec([1 1], LowerLimit=-1, UpperLimit=1);
actInfo.Name = "pwm";
env = rlFunctionEnv(obsInfo, actInfo, ...
    @(a, ls) edgeEnvStep(a, ls, p, r), @() edgeEnvReset(p, r));
end
