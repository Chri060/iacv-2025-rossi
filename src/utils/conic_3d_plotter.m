function [] = conic_3d_plotter(A)
    % Function to draw a conic in 3D space given the conic matrix A
    %
    % Inputs:
    %   A - 3x3 conic matrix that defines the quadratic form of the conic.
    %
    % Output:
    %   A 3D plot of the conic.
    
    % Create a meshgrid of x and y values in the range [-1000, 1000]
    [X, Y] = meshgrid(-1000:10:1000, -1000:10:1000);  % Adjust step size (50) as needed
    
    % Initialize Z values to NaN
    Z = NaN(size(X));
    
    % Solve for Z based on the conic equation
    for i = 1:size(X, 1)
        for j = 1:size(X, 2)
            % Homogeneous coordinates (x, y, 1)
            point = [X(i, j); Y(i, j); 1];
            
            % Check if the point satisfies the conic equation (A * point^2 = 0)
            if abs(point' * A * point) < 1e-6
                Z(i, j) = 0; % Z = 0 at the conic
            end
        end
    end
    
    % Plot the conic in 3D
    
    surf(X, Y, Z, 'EdgeColor', 'none');
    title('3D Conic Plot');
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

end