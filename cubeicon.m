thickness = 0.2;
layers = 25;
cube_size = 10;
blue_color = [0 0.5 1];
blue_edge_color = [0 0.3 0.8];
red_color = [1 0.2 0.2];
red_edge_color = [1 0.2 0.2];
light_red = [1 0 0];
line_width = 2;

red_cube_size = cube_size / 3;
red_thickness = thickness * 2;
red_layers = 5;
total_red_span = red_layers * 2;

tiny_offset = 0.002;  % Much smaller offset
margin = 0.1;
x_offset = cube_size - red_cube_size - margin;  % Remove the +total_red_span
y_offset = margin - tiny_offset;  % Small forward movement

hold on;
% Draw blue layers
for i = 1:layers
    z_bottom = (i-1) * thickness;
    z_top = z_bottom + thickness;
    x = [0 cube_size cube_size 0];
    y = [0 0 cube_size cube_size];
    patch(x, y, [z_bottom z_bottom z_bottom z_bottom], blue_color, ...
          'EdgeColor', blue_edge_color, 'LineWidth', line_width);
    patch(x, y, [z_top z_top z_top z_top], blue_color, ...
          'EdgeColor', blue_edge_color, 'LineWidth', line_width);
end

% Red cube
start_layer = layers - total_red_span;
for i = 1:red_layers
    z_bottom = (start_layer + (i-1) * 2) * thickness + tiny_offset;  % Small Z offset
    z_top = z_bottom + red_thickness;  % Remove tiny_offset from here
    
    x1 = x_offset;
    x2 = x_offset + red_cube_size;
    y1 = y_offset;
    y2 = y_offset + red_cube_size;
    
    % All your patch commands remain the same...
    patch([x1 x2 x2 x1], [y1 y1 y2 y2], [z_bottom z_bottom z_bottom z_bottom], red_color, ...
          'EdgeColor', red_edge_color, 'LineWidth', line_width);
    patch([x1 x2 x2 x1], [y1 y1 y2 y2], [z_top z_top z_top z_top], red_color, ...
          'EdgeColor', red_edge_color, 'LineWidth', line_width);
    patch([x1 x2 x2 x1], [y1 y1 y1 y1], [z_bottom z_bottom z_top z_top], light_red, ...
          'EdgeColor', red_edge_color, 'LineWidth', line_width);
    patch([x1 x2 x2 x1], [y2 y2 y2 y2], [z_bottom z_bottom z_top z_top], light_red, ...
          'EdgeColor', red_edge_color, 'LineWidth', line_width);
    patch([x1 x1 x1 x1], [y1 y2 y2 y1], [z_bottom z_bottom z_top z_top], light_red, ...
          'EdgeColor', red_edge_color, 'LineWidth', line_width);
    patch([x2 x2 x2 x2], [y1 y2 y2 y1], [z_bottom z_bottom z_top z_top], light_red, ...
          'EdgeColor', red_edge_color, 'LineWidth', line_width);
end

xlim([0, cube_size])
ylim([0, cube_size])
zlim([0, layers * thickness])
set(gca,'XTick',[])
set(gca,'YTick',[])
set(gca,'ZTick',[])
box off;
axis off;
h = gca;
h.XAxis.Visible = 'off';
h.YAxis.Visible = 'off';
view(38, 17);
% view(-1, 0);
