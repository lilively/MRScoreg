figure
% Axes
line([0 1],[0 0],[0 0],'Color','k','LineWidth',1.5) % X = columns
line([0 0],[0 1],[0 0],'Color','k','LineWidth',1.5) % Y = rows
line([0 0],[0 0],[0 1],'Color','k','LineWidth',1.5) % Z = depth

% Arrowheads
hold on
quiver3(1,0,0,0.001,0,0,'k','MaxHeadSize',1.5,'AutoScale','off')
quiver3(0,1,0,0,0.001,0,'k','MaxHeadSize',1.5,'AutoScale','off')
quiver3(0,0,1,0,0,0.001,'k','MaxHeadSize',1.5,'AutoScale','off')
% 
% % Labels (Row/Col/Depth)
% text(1.05,0,0,'Column','FontSize',10,'HorizontalAlignment','right')
% text(0,1.05,0,'Row','FontSize',10,'HorizontalAlignment','center')
% text(0,0,1.05,'Depth','FontSize',10,'HorizontalAlignment','center')

axis equal
axis off
view(100,10)
