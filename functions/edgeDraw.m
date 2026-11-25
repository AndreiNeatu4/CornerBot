function edgeDraw(s, p, info)
% 3D view of the cube on its edge. info: text shown on top.
a = p.a; rw = 0.063;
fig = findobj(groot, "Type", "figure", "Tag", "edgeView3");
if isempty(fig)
    fig = figure(Tag="edgeView3", Name="CornerBot edge 3D", NumberTitle="off", Color="w");
    ax = axes(fig); hold(ax, "on"); axis(ax, "equal"); axis(ax, "off");
    view(ax, 35, 18);
    L = 0.2;
    xlim(ax, [-L L]); ylim(ax, [-L L]); zlim(ax, [0 0.25]);
    patch(ax, [-L L L -L], [-L -L L L], [0 0 0 0], [0.93 0.93 0.93], EdgeColor="none");
    camlight(ax); lighting(ax, "gouraud");
    h.cube = patch(ax, Vertices=nan(8,3), Faces=cubeFaces(), FaceColor=[0.75 0.85 1], ...
        FaceAlpha=0.15, EdgeColor=[0.2 0.3 0.6], LineWidth=2);
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

th = s.x(1); psi = s.x(4);
W = @(P) toWorld(P, th);              % local (x, u, v) -> world

% Cube: edge on ground along x, u = v = 0
[X, U, V] = ndgrid([-a/2 a/2], [0 a], [0 a]);
set(h.cube, Vertices=W([X(:) U(:) V(:)]));
if s.fallen, h.cube.FaceColor = [1 0.6 0.6]; else, h.cube.FaceColor = [0.75 0.85 1]; end

% Wheels near faces x = a/2, u = a, v = a; wheel 1 balances the edge
ang = linspace(0, 2*pi, 30)';
c = a/2; in = 0.02;
spokeAng = [psi 0 0];
centers = {[a/2-in c c], [0 a-in c], [0 c a-in]};
for i = 1:3
    ring = rw*[cos(ang) sin(ang)];
    sp = rw*[cos(spokeAng(i) + [0; pi; NaN; pi/2; 3*pi/2]) sin(spokeAng(i) + [0; pi; NaN; pi/2; 3*pi/2])];
    sp(3,:) = NaN;
    P  = onPlane(i, centers{i}, ring);
    Ps = onPlane(i, centers{i}, sp);
    P = W(P); Ps = W(Ps);
    set(h.wheel(i), XData=P(:,1), YData=P(:,2), ZData=P(:,3));
    set(h.spoke(i), XData=Ps(:,1), YData=Ps(:,2), ZData=Ps(:,3));
end

% Push arrow at COM
com = W([0 c c]);
if isfield(info, "push") && info.push ~= 0
    d = sign(info.push);
    set(h.push, XData=com(1), YData=com(2) - d*0.12, ZData=com(3), UData=0, VData=d*0.09, WData=0);
else
    set(h.push, UData=0, VData=0, WData=0);
end
h.txt.String = info.text;
drawnow limitrate;
end

function P = toWorld(P, th)
% Diagonal u = v vertical at th = 0, then tilt about the x axis.
phi = th;
y0 = (P(:,2) - P(:,3))/sqrt(2);
z0 = (P(:,2) + P(:,3))/sqrt(2);
P = [P(:,1), y0*cos(phi) + z0*sin(phi), -y0*sin(phi) + z0*cos(phi)];
end

function P = onPlane(i, c, q)
% Circle points q (2 cols) on the plane of wheel i.
n = size(q, 1);
switch i
    case 1, P = [repmat(c(1), n, 1), c(2) + q(:,1), c(3) + q(:,2)];
    case 2, P = [c(1) + q(:,1), repmat(c(2), n, 1), c(3) + q(:,2)];
    case 3, P = [c(1) + q(:,1), c(2) + q(:,2), repmat(c(3), n, 1)];
end
end

function F = cubeFaces()
% Vertex order from ndgrid([x], [u], [v]).
F = [1 2 4 3; 5 6 8 7; 1 2 6 5; 3 4 8 7; 1 3 7 5; 2 4 8 6];
end
