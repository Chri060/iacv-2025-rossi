function [] = point_plotter(p)
    % POINT_PLOTTER Plots a point on the current figure.
    %
    % This function plots a single point on a previously opened image or figure.
    % The point is displayed as a red dot by default with a specified marker size.
    %
    % Inputs:
    %   p - 1x2 or 1x3 vector representing the coordinates of the point to be plotted.
    %       If homogeneous coordinates (1x3), the function normalizes them.
    %
    % Outputs:
    %   None. The point is drawn directly on the current figure or image.
    %
    % Example:
    %   p = [100, 200];
    %   point_plotter(p);
    %   % Plots a red point at (100, 200).
    %
    % Note:
    %   The color and style are hardcoded as 'r.' (red dot) with a marker size of 35.
    %   For custom styling, modify the plot command directly in the code.
    
    % Normalize the point if in homogeneous coordinates
    if numel(p) == 3
        p = p(1:2) ./ p(3);
    end

    % Plot the point as a red dot with a large marker size
    plot(p(1), p(2), 'r.', 'MarkerSize', 35);
end