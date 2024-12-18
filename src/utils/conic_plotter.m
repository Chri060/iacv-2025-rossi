function conic_plotter(image, conic_matrix, point, label, conic_num)
    % This function draws a conic defined by the conic matrix on top of the given image.
    % Inputs:
    %   image: The input image (grayscale or RGB).
    %   conic_matrix: The 3x3 conic matrix.
    
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
    

    for k = 1:conic_num
        conic = conic_matrix(1 + 3 * (k - 1): 3 + 3 * (k - 1), 1:3);
        % Evaluate the conic equation for each point
        conic_values = sum((homogeneous_coords' * conic) .* homogeneous_coords', 2);
        
        % Reshape the conic values to match the image grid
        conic_values = reshape(conic_values, [rows, cols]);
        
        % Plot the conic: We will contour the image where the conic equation holds
        contour(X, Y, conic_values, [0, 0], 'r', 'LineWidth', 2);  % 'r' is red color
    
        % Mark the origin of the conic (x_center, y_center)
        text(point(k, 1), point(k, 2) - 20, label(k), 'Color', 'black', 'FontSize', 20, 'FontWeight', 'bold');
    end 






    hold off;
end
