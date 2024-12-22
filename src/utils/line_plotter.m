function [] = line_plotter(l)
    % LINE_PLOTTER Plots a 2D line on the current figure.
    %
    % This function visualizes a line defined in homogeneous coordinates
    % (ax + by + c = 0) on a pre-existing figure. The function automatically
    % adjusts the plotting range based on the current axis limits.
    %
    % Inputs:
    %   l - 1x3 vector [a, b, c] representing the line in homogeneous coordinates.
    %
    % Outputs:
    %   None. The line is directly drawn on the current figure.
    %
    % Example:
    %   l = [1, -2, 3]; % Line: x - 2y + 3 = 0
    %   line_plotter(l);
    %   % Plots the line with a red solid style on the current figure.

    % Generate x-coordinates within the current axis limits
    x = linspace(0, 10000);  

    % Compute corresponding y-coordinates
    if l(2) ~= 0
        % Standard line case
        y = (-l(1) * x - l(3)) / l(2);
    else
        % Handle vertical line case (b = 0)
        x = -l(3) / l(1) * ones(1, 100); % Constant x-coordinate
        y = linspace(y_limits(1), y_limits(2), 100);
    end

    % Plot the line
    plot(x, y, 'r-', 'LineWidth', 1.5);
end