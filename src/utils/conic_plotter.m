function [] = conic_plotter(image, conic_matrix, point, label, conic_num)
    % CONIC_PLOTTER Plots conics defined by their conic matrices on an image.
    %
    % This function displays an image and overlays conics defined by their
    % conic matrices. It also marks specific points with corresponding labels.
    %
    % Inputs:
    %   image        - The input image (grayscale or RGB).
    %   conic_matrix - A (3 * conic_num)x3 matrix where each 3x3 block 
    %                  represents a conic matrix.
    %   points       - Nx2 matrix of [x, y] coordinates for points to mark.
    %   labels       - Cell array of strings with labels for the points.
    %   conic_num    - Number of conics to plot.
    %
    % Example:
    %   img = imread('example.jpg');
    %   conics = [1, 0, -100; 0, 1, -100; -100, -100, 1;  % Conic 1
    %             1, 0, -50; 0, 1, -50; -50, -50, 1];    % Conic 2
    %   points = [100, 100; 50, 50];
    %   labels = {'A', 'B'};
    %   conic_plotter(img, conics, points, labels, 2);
    %
    % Notes:
    %   - Each 3x3 block in `conic_matrix` corresponds to one conic.
    %   - `labels` must match the number of `points`.
    
    % Display the image
    figure();
    imshow(image);
    hold on;
    impixelinfo;
    
    % Get the size of the image
    [rows, cols, ~] = size(image);
    
    % Create grid of points covering the image
    [X, Y] = meshgrid(1:cols, 1:rows);
    
    % Convert to homogeneous coordinates (x, y, 1)
    homogeneous_coords = [X(:)'; Y(:)'; ones(1, numel(X))];
    
    % Loop through and plot each conic
    for k = 1:conic_num
        % Extract the conic matrix for the current conic
        conic = conic_matrix(1 + 3 * (k - 1): 3 + 3 * (k - 1), 1:3);

        % Evaluate the conic equation for each point
        conic_values = sum((homogeneous_coords' * conic) .* homogeneous_coords', 2);
        
        % Reshape the conic values to match the image grid
        conic_values = reshape(conic_values, [rows, cols]);
        
        % Plot the conic as a contour where the conic equation holds
        contour(X, Y, conic_values, [0, 0], 'r', 'LineWidth', 2);  % 'r' is red color
    
        % Add the label to the curve
        text(point(k, 1), point(k, 2) - 20, label(k), 'Color', 'black', 'FontSize', 20, 'FontWeight', 'bold');
    end 

    hold off;
end
