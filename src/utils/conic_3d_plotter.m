function [] = conic_3d_plotter(A)
    % Function to draw a conic in 3D space given the conic matrix A
    %
    % Inputs:
    %   A - 3x3 conic matrix that defines the quadratic form of the conic.
    %
    % Output:
    %   A 3D plot of the conic.

    % Create a meshgrid of x and y values in the range [-1000, 1000]
    [X, Y] = meshgrid(-1000:1:1000, -1000:1:1000);  
    
    conic = A;
    % Convert to homogeneous coordinates (x, y, 1)
    homogeneous_coords = [X(:)'; Y(:)'; ones(1, numel(X))];
 
    % Evaluate the conic equation for each point
    conic_values = sum((homogeneous_coords' * conic) .* homogeneous_coords', 2);
    
    % Reshape the conic values to match the image grid
    conic_values = reshape(conic_values, [2001, 2001]);
    
    % Plot the conic as a contour where the conic equation holds
    contour(X, Y, conic_values, [0, 0], 'r', 'LineWidth', 2);  % 'r' is red color
end