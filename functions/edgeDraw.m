function edgeDraw(s, p, info)
% Side view of the cube on its edge. info: text shown on top.
fig = findobj(groot, "Type", "figure", "Tag", "edgeView");
if isempty(fig)
    fig = figure(Tag="edgeView", Name="CornerBot edge", NumberTitle="off", Color="w");
    ax = axes(fig); hold(ax, "on"); axis(ax, "equal"); axis(ax, "off");
    lim = 0.17;
    xlim(ax, [-lim lim]); ylim(ax, [-0.02 0.24]);
    plot(ax, [-lim lim], [0 0], "k", LineWidth=2);
    h.cube  = patch(ax, nan, nan, [0.85 0.9 1], EdgeColor=[0.2 0.3 0.6], LineWidth=2);
    h.wheel = plot(ax, nan, nan, Color=[0.95 0.5 0.1], LineWidth=3);
    h.spoke = plot(ax, nan, nan, Color=[0.95 0.5 0.1], LineWidth=2);
    h.push  = quiver(ax, 0, 0, 0, 0, 0, Color="r", LineWidth=2, MaxHeadSize=2);
    h.txt   = text(ax, -lim, 0.23, "", FontSize=11, Color="k", VerticalAlignment="top");
    fig.UserData = h;
end
h = fig.UserData;

th = s.x(1); psi = s.x(4);
l = p.l; rw = 0.063;
c = l*[sin(th) cos(th)];
R = [cos(th) -sin(th); sin(th) cos(th)];
v = c + ([0 -l; l 0; 0 l; -l 0]*R);
a = linspace(0, 2*pi, 40);
set(h.cube, XData=v(:,1), YData=v(:,2));
if s.fallen, h.cube.FaceColor = [1 0.8 0.8]; else, h.cube.FaceColor = [0.85 0.9 1]; end
set(h.wheel, XData=c(1) + rw*cos(a), YData=c(2) + rw*sin(a));
set(h.spoke, XData=c(1) + rw*[-1 1]*cos(psi + th), YData=c(2) + rw*[-1 1]*sin(psi + th));
if isfield(info, "push") && info.push ~= 0
    set(h.push, XData=c(1) - sign(info.push)*0.08, YData=c(2), UData=sign(info.push)*0.06, VData=0);
else
    set(h.push, UData=0, VData=0);
end
h.txt.String = info.text;
drawnow limitrate;
end
