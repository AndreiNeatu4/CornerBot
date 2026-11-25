function env = createCornerEnv(p, r)
% rlFunctionEnv around the corner model.
obsInfo = rlNumericSpec([10 1]);
obsInfo.Name = "obs";
actInfo = rlNumericSpec([3 1], LowerLimit=-1, UpperLimit=1);
actInfo.Name = "pwm";
env = rlFunctionEnv(obsInfo, actInfo, ...
    @(a, ls) cornerEnvStep(a, ls, p, r), @() cornerEnvReset(p, r));
end
