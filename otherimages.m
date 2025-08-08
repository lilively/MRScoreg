figure(1);
clf;
rect_width = 6;
rect_height = 1.2;
num_rectangles = 5;
num_lines_per_row = 15;
line_style = 'vertical';

% Define the missing color variables
rect_color = 'r';  % Black rectangles
line_color = 'b';  % Blue lines

hold on;
% Draw 5 rectangles with 10 parallel horizontal blue lines inside each
for i = 1:num_rectangles
    y_bottom = (i-1) * rect_height;  % This was also an issue - should be spaced by rect_height
    y_top = y_bottom + rect_height;

    % Draw rectangle outline
    rectangle('Position', [0, y_bottom, rect_width, rect_height], ...
              'EdgeColor', rect_color, 'LineWidth', 3, 'FaceColor', 'none');

    % Add 10 parallel horizontal blue lines across the full width
    y_positions = linspace(y_bottom + 0.1, y_top - 0.1, 10);  % Changed to y_top - 0.1

    for j = 1:10
        % Draw full-width horizontal blue lines
        plot([0, rect_width], [y_positions(j), y_positions(j)], ...
             line_color, 'LineWidth', 1);
    end
end

axis equal;
set(gca,'XTick',[])
set(gca,'YTick',[])
xlim([-0.5, rect_width + 0.5]);
ylim([-0.5, num_rectangles * rect_height + 0.5]);  
grid off;

%%%
