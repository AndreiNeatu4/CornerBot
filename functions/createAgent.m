function agent = createAgent(type, env, p)
% DDPG, TD3 or SAC with 2 x 64 networks.
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
nObs = obsInfo.Dimension(1);
nAct = actInfo.Dimension(1);
n = 64;

switch upper(type)
    case {"DDPG", "TD3"}
        actorNet = dlnetwork([
            featureInputLayer(nObs)
            fullyConnectedLayer(n)
            reluLayer
            fullyConnectedLayer(n)
            reluLayer
            fullyConnectedLayer(nAct)
            tanhLayer]);
        actor = rlContinuousDeterministicActor(actorNet, obsInfo, actInfo);

        nCritic = 1 + strcmpi(type, "TD3");
        critics = cell(1, nCritic);
        for i = 1:nCritic
            critics{i} = rlQValueFunction(criticNet(nObs, nAct, n), ...
                obsInfo, actInfo, ObservationInputNames="obs", ActionInputNames="act");
        end
        critics = [critics{:}];

        if strcmpi(type, "DDPG")
            opt = rlDDPGAgentOptions;
        else
            opt = rlTD3AgentOptions;
        end
        if isprop(opt, "NoiseOptions"), noise = "NoiseOptions"; else, noise = "ExplorationModel"; end
        opt.(noise).StandardDeviation = 0.3;
        opt.(noise).StandardDeviationDecayRate = 1e-5;
        opt = commonOpts(opt, p);
        if strcmpi(type, "DDPG")
            agent = rlDDPGAgent(actor, critics, opt);
        else
            agent = rlTD3Agent(actor, critics, opt);
        end

    case "SAC"
        init = rlAgentInitializationOptions(NumHiddenUnit=n);
        opt = commonOpts(rlSACAgentOptions, p);
        agent = rlSACAgent(obsInfo, actInfo, init, opt);
end
end

function net = criticNet(nObs, nAct, n)
net = dlnetwork;
net = addLayers(net, featureInputLayer(nObs, Name="obs"));
net = addLayers(net, featureInputLayer(nAct, Name="act"));
net = addLayers(net, [
    concatenationLayer(1, 2, Name="cat")
    fullyConnectedLayer(n)
    reluLayer
    fullyConnectedLayer(n)
    reluLayer
    fullyConnectedLayer(1)]);
net = connectLayers(net, "obs", "cat/in1");
net = connectLayers(net, "act", "cat/in2");
net = initialize(net);
end

function opt = commonOpts(opt, p)
opt.SampleTime = p.dt;
opt.DiscountFactor = 0.99;
opt.MiniBatchSize = 256;
opt.ExperienceBufferLength = 1e6;
opt.ActorOptimizerOptions.LearnRate = 1e-4;
opt.ActorOptimizerOptions.GradientThreshold = 1;
for i = 1:numel(opt.CriticOptimizerOptions)
    opt.CriticOptimizerOptions(i).LearnRate = 1e-3;
    opt.CriticOptimizerOptions(i).GradientThreshold = 1;
end
end
