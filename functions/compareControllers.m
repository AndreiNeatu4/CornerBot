function T = compareControllers(ctrls, names, p, figDir)
% Run evaluate on each controller, table and plots.
if nargin < 3, p = cubeParams(); end
if nargin < 4, figDir = ""; end
n = numel(ctrls);
R = cell(n,1);
for i = 1:n, R{i} = evaluate(ctrls{i}, p, names{i}); end
R = [R{:}];

effRatio = [R.effort]'/R(1).effort;
T = table(string(names(:)), [R.upright]', [R.meanTUp]', [R.meanTilt]', ...
    [R.pushes]', [R.effort]', effRatio, [R.pass]', ...
    VariableNames=["Controller" "Upright_of_20" "MeanTimeUp_s" "MeanTilt_deg" ...
                   "Pushes_of_10" "MeanPWM" "EffortVsFirst" "Pass"]);

f = figure(Visible="off", Position=[0 0 900 350]);
tiledlayout(1,2);
nexttile; hold on;
for i = 1:n, plot(abs(R(i).th0), R(i).tUp, "o", DisplayName=names{i}); end
xlabel("|start tilt| [deg]"); ylabel("Time up [s]"); grid on; legend(Location="southwest");
nexttile; hold on;
for i = 1:n, plot(abs(R(i).pushT), R(i).pushMax, "o-", DisplayName=names{i}); end
yline(p.fallDeg, "--", "fall"); xlabel("Push [N m]"); ylabel("Max tilt [deg]"); grid on;
if figDir ~= ""
    exportgraphics(f, fullfile(figDir, "edge_comparison.png"));
    writetable(T, fullfile(figDir, "edge_comparison.csv"));
end
end
