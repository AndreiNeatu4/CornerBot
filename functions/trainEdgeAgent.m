function [agent, stats] = trainEdgeAgent(type, maxEpisodes, plots, renderEvery)
% Two-phase training on the edge, saved to models/.
% Phase 1: small starts. Phase 2: wider starts and pushes.
if nargin < 2, maxEpisodes = 2000; end
if nargin < 3, plots = "training-progress"; end
if nargin < 4, renderEvery = 0; end
p = cubeParams();
r = rlParams();
r.renderEvery = renderEvery;

env = createEdgeEnv(p, r);
agent = createAgent(type, env, p);
stats = {runPhase(agent, env, r, maxEpisodes, plots, 0.9)};

r.initTilt = 1.5;
r.nPush = 3;
env = createEdgeEnv(p, r);
stats{2} = runPhase(agent, env, r, maxEpisodes, plots, 0.85);

root = fileparts(fileparts(mfilename("fullpath")));
save(fullfile(root, "models", "edge" + upper(type) + ".mat"), "agent", "stats", "p", "r");
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
