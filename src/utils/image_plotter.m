function [] = image_plotter(img, points, lines, points_label)
    % IMAGE_PLOTTER Visualizes an image with overlaid points and lines.
    %
    % This function displays an image and overlays points and lines on it.
    % Optionally, it labels the points with their indices.
    %
    % Inputs:
    %   img          - Image to be displayed.
    %   points       - Nx2 or Nx3 matrix where each row represents a point
    %                  in 2D or homogeneous coordinates.
    %   lines        - Mx3 matrix where each row represents a line
    %                  in homogeneous coordinates [a, b, c].
    %   points_label - Boolean (1 or 0). If set to 1, the points are labeled
    %                  with their indices. If 0, no labels are displayed.
    %
    % Outputs:
    %   None. The visualization is displayed in a new figure window.
    %
    % Example:
    %   img = imread('example.jpg');
    %   points = [100, 200; 300, 400];
    %   lines = [1, -1, -50; 0, 1, -150];
    %   image_plotter(img, points, lines, 1);
    %   % Displays the image with 2 points, 2 lines, and labeled points.
    %
    % Notes:
    %   - Points are plotted in red, and lines are plotted in red by default.

    % Open a new figure and display the image
    figure();
    imshow(img);
    hold on;
    impixelinfo; 
    
    % Plot all lines
    for k = 1:size(lines, 1)
        line_plotter(lines(k, :))
    end 

    % Plot all points
    for k = 1:size(points, 1)
        point_plotter(points(k, :))

        % Add labels if points_label is enabled
        if points_label ~= 0
            text(points(k, 1), points(k, 2), num2str(k), 'Color', 'black', 'FontSize', 20);
        end 
    end
    
    hold off;
end