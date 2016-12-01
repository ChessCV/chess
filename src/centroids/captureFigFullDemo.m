figure('units','normalized','outerposition',[0 0 1 1])
visualizeCentroids
drawnow
ax = gca;
ax.Units = 'pixels';
pos = ax.Position
marg = 2;
% rect = [-marg, -marg, pos(3)+2*marg, pos(4)+2*marg];
rect = [-marg, -marg, pos(3)+2*marg, pos(4)+2*marg];
F = getframe(gca,rect);
ax.Units = 'normalized';
figure
imshow(F.cdata)
