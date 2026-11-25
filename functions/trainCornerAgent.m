function [agent, stats] = trainCornerAgent(corner, type, maxEpisodes, plots, renderEvery)
% Two-phase training on a corner (1 = A, 2 = B, "all" = random corner each episode).
if nargin < 3, maxEpisodes = 3000; end
if nargin < 4, plots = "training-progress"; end
if nargin < 5, renderEvery = 0; end
p = cubeParams();
r = rlParams();
if corner == "all"
    r.allPositions = true; tag = "All";
else
    p.corner = corner; tag = char('A' + corner - 1);
end
r.obsScale = [7 7 100 100 100 300 300 2000 2000 900];
r.renderEvery = renderEvery;
name = "corner" + tag + "_" + upper(type);
root = fileparts(fileparts(mfilename("fullpath")));

env = createCornerEnv(p, r);
agent = createAgent(type, env, p);
stats = {runPhase(agent, env, r, maxEpisodes, plots, 0.9)};
save(fullfile(root, "models", name + "_phase1.mat"), "agent", "stats", "p", "r");

r.initTilt = 1.0;
r.nPush = 3;
r.pushMax = 0.04;
env = createCornerEnv(p, r);
stats{2} = runPhase(agent, env, r, maxEpisodes, plots, 0.85);
save(fullfile(root, "models", name + ".mat"), "agent", "stats", "p", "r");
end

function s = runPhase(agent, env, r, maxEpisodes, plots, target)
opt = rlTrainingOptions( ...
    MaxEpisodes = maxEpisodes, ...
    MaxStepsPerEpisode = r.maxSteps, ...
    ScoreAveragingWindowLength = 50, ...
    StopTrainingCriteria = "AverageReward", ...
    StopTrainingValue = target*r.maxSteps, ...
    Plots = plots, ...
    Verbose = plots == "none");
s = train(agent, env, opt);
end
