function [] = point_plotter(p)
    % Function used to plot a point
    %
    % Inputs:
    %   p - vector with the coordinates of the point to be plotted
    %   color - color and style for the line displayed
    %           The possible options are: 
    %           b (blue), g (green), k (black), m (magenta), c (cyan), y (yellow)
    %           -- (dashed), : (dotted), . (dash-dot)
    %
    % Output:
    %   draws the point directly in the previously opened image

    % Plot a point on the given coordinates with the selected color
    plot(p(1), p(2), 'r.', 'MarkerSize', 35);
end