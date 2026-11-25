function [agent, stats] = trainEdgeAgent(type, maxEpisodes, plots, renderEvery, allEdges)
% Two-phase training on the edge, saved to models/.
% Phase 1: small starts. Phase 2: wider starts and pushes.
if nargin < 2, maxEpisodes = 2000; end
if nargin < 3, plots = "training-progress"; end
if nargin < 4, renderEvery = 0; end
if nargin < 5, allEdges = false; end
p = cubeParams();
r = rlParams();
r.renderEvery = renderEvery;
r.allPositions = allEdges;
name = "edge" + string(repmat('All_', 1, allEdges)) + upper(type);

env = createEdgeEnv(p, r);
agent = createAgent(type, env, p);
stats = {runPhase(agent, env, r, maxEpisodes, plots, 0.9)};
root = fileparts(fileparts(mfilename("fullpath")));
save(fullfile(root, "models", name + "_phase1.mat"), "agent", "stats", "p", "r");

r.initTilt = 1.0;
r.nPush = 3;
r.pushMax = 0.04;
env = createEdgeEnv(p, r);
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
