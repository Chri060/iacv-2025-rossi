function [] = camera_plotter(cameraRotation, cameraPosition)
    % CAMERA_PLOTTER Plots a 3D camera with its position and orientation.
    %
    % This function visualizes the camera's position and its orientation in a 3D space.
    % The camera's position is shown as a red dot, and its axes are represented by
    % vectors originating from the camera position.
    %
    % Inputs:
    %   cameraRotation - 3x3 rotation matrix representing the camera's orientation.
    %                    Each column corresponds to an axis: 
    %                    - First column: X-axis
    %                    - Second column: Y-axis
    %                    - Third column: Z-axis
    %   cameraPosition - 1x3 vector [x, y, z] representing the camera's position in 3D.
    %
    % Example:
    %   R = eye(3); % Camera pointing along default axes
    %   P = [0, 0, 0]; % Camera at the origin
    %   camera_plotter(R, P);
    %
    % Notes:
    %   - Ensure that the rotation matrix is valid (orthogonal with determinant 1).
    %   - Adjust the `axisLength` variable to control the scale of the axes.

    % Define the axis length for the camera axes
    axisLength = 200;
    
    % Extract camera axes from the rotation matrix (each column represents an axis)
    cameraAxes = cameraRotation * axisLength;  % Scale the axes
    
    % Plot camera position as a red dot
    plot3(cameraPosition(1), cameraPosition(2), cameraPosition(3), 'ro', 'MarkerSize', 10);
    
    % Plot the camera axes using quiver3 (X-axis in red, Y-axis in green, Z-axis in blue)
    quiver3(cameraPosition(1), cameraPosition(2), cameraPosition(3), cameraAxes(1,1), cameraAxes(2,1), cameraAxes(3,1), 'r', 'LineWidth', 2);  % X-axis
    quiver3(cameraPosition(1), cameraPosition(2), cameraPosition(3), cameraAxes(1,2), cameraAxes(2,2), cameraAxes(3,2), 'g', 'LineWidth', 2);  % Y-axis
    quiver3(cameraPosition(1), cameraPosition(2), cameraPosition(3), cameraAxes(1,3), cameraAxes(2,3), cameraAxes(3,3), 'b', 'LineWidth', 2);  % Z-axis
end