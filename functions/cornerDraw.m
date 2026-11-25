function cornerDraw(s, p, info)
% 3D view of the cube on its corner.
a = p.a; rw = 0.063; in = 0.02;
fig = findobj(groot, "Type", "figure", "Tag", "cornerView");
if isempty(fig)
    fig = figure(Tag="cornerView", Name="CornerBot corner 3D", NumberTitle="off", Color="w");
    ax = axes(fig); hold(ax, "on"); axis(ax, "equal"); axis(ax, "off");
    view(ax, 35, 15);
    L = 0.22;
    xlim(ax, [-L L]); ylim(ax, [-L L]); zlim(ax, [0 0.3]);
    patch(ax, [-L L L -L], [-L -L L L], [0 0 0 0], [0.93 0.93 0.93], EdgeColor="none");
    camlight(ax); lighting(ax, "gouraud");
    h.cube = patch(ax, Vertices=nan(8,3), Faces=[1 2 4 3; 5 6 8 7; 1 2 6 5; 3 4 8 7; 1 3 7 5; 2 4 8 6], ...
        FaceColor=[0.75 0.85 1], FaceAlpha=0.15, EdgeColor=[0.2 0.3 0.6], LineWidth=2);
    for i = 1:3
        h.wheel(i) = patch(ax, nan, nan, nan, [0.95 0.5 0.1], FaceAlpha=0.6, EdgeColor=[0.8 0.35 0], LineWidth=1.5);
        h.spoke(i) = plot3(ax, nan, nan, nan, Color=[0.6 0.25 0], LineWidth=2);
    end
    h.push = quiver3(ax, 0, 0, 0, 0, 0, 0, 0, Color="r", LineWidth=3, MaxHeadSize=1);
    h.txt  = text(ax, 0, 0, 0, "", Units="normalized", Position=[0 1 0], FontSize=11, ...
        Color="k", VerticalAlignment="top");
    fig.UserData = h;
end
h = fig.UserData;
R = s.R;

[X, Y, Z] = ndgrid([0 a], [0 a], [0 a]);
pv = s.g.pivot';
set(h.cube, Vertices=(([X(:) Y(:) Z(:)] - pv)*R'));
if s.fallen, h.cube.FaceColor = [1 0.6 0.6]; else, h.cube.FaceColor = [0.75 0.85 1]; end

ang = linspace(0, 2*pi, 30)';
sa = [0; pi; NaN; pi/2; 3*pi/2];
for i = 1:3
    j = setdiff(1:3, i);
    c = a/2*ones(1,3); c(i) = in;          % faces at the pivot corner
    th = s.g.W(:,i)'*s.g.W*s.psi;          % wheel angle about body axis i
    ring = zeros(30,3); ring(:,i) = c(i);
    ring(:,j) = c(j) + rw*[cos(ang) sin(ang)];
    sp = zeros(5,3); sp(:,i) = c(i);
    sp(:,j) = c(j) + rw*[cos(th + sa) sin(th + sa)];
    ring = (ring - pv)*R'; sp = (sp - pv)*R';
    set(h.wheel(i), XData=ring(:,1), YData=ring(:,2), ZData=ring(:,3));
    set(h.spoke(i), XData=sp(:,1), YData=sp(:,2), ZData=sp(:,3));
end

com = (R*s.g.r)';
if isfield(info, "push") && any(info.push ~= 0)
    d = info.push(:)'/norm(info.push)*0.09;
    set(h.push, XData=com(1) - d(1)*1.3, YData=com(2) - d(2)*1.3, ZData=com(3), UData=d(1), VData=d(2), WData=0);
else
    set(h.push, UData=0, VData=0, WData=0);
end
h.txt.String = info.text;
drawnow limitrate;
end
