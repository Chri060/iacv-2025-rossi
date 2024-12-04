function line_plotter(l, min, max, color)
    % Function used to plot a line
    %
    % Inputs:
    %   l - 1x3 vector [a, b, c] representing the line
    %   min - scalar representing the left border for the x coordinate 
    %   max - scalar representing the right border for the x coordinate 
    %   color - color and style for the line displayed
    %           The possible options are: 
    %           b (blue), g (green), k (black), m (magenta), c (cyan), y (yellow)
    %           -- (dashed), : (dotted), -. (dash-dot)
    %
    % Output:
    %   draws the line directly in the previously opened image

    % Create a vector of points between 
    x = linspace(min, max);  

    % Create a vector of the corrisponding y for each point in vector x
    y = (- l(1) * x - l(3)) / l(2);

    % Plot the line with the selected color
    plot(x, y, color, 'LineWidth', 1.5);
end