function [] = object_plotter(points, camera, cameraRotation, cameraPosition)
    % OBJECT_PLOTTER Plots a 3D object and optionally a camera in a 3D space.
    %
    % This function visualizes a 3D object defined by its vertices and optionally 
    % overlays a camera representation in the same space. The object is plotted 
    % with colored point clouds for its facades and semi-transparent faces to
    % represent a 3D cuboid.
    %
    % Inputs:
    %   points          - Nx3 matrix containing the 3D coordinates of the object's vertices.
    %                     The first 4 points are the front facade, and the next 4 are the back facade.
    %   camera          - Integer (0 or 1). If non-zero, the camera is plotted.
    %   cameraRotation  - 3x3 rotation matrix representing the camera's orientation.
    %   cameraPosition  - 1x3 vector representing the camera's position in 3D space.
    %
    % Outputs:
    %   None. The function directly creates a 3D plot in a new figure.
    %
    % Example:
    %   points = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];
    %   camera = 1;
    %   cameraRotation = eye(3);
    %   cameraPosition = [5, 5, 5];
    %   object_plotter(points, camera, cameraRotation, cameraPosition);
    %
    % Note:
    %   - This function assumes the points form a cuboid with vertices ordered
    %     sequentially for front and back facades.
    %   - The `camera_plotter` function is implemented separately to handle
    %     camera visualization.

    % Create a new figure and enable 3D plotting
    figure();
    hold on;

    % Separate points into front and back facades
    front_facade = points(1:4, :);
    back_facade = points(5:8, :);
    
    % Plot the facades point clouds
    pcshow(pointCloud(front_facade, Color='black'), 'MarkerSize', 800, 'BackgroundColor', [1, 1, 1]);
    pcshow(pointCloud(back_facade, Color='black'), 'MarkerSize', 800, 'BackgroundColor', [1, 1, 1]);
    
    % Set color for the cuboid faces
    gray = [0.7, 0.7, 0.7];
    
    % Define the faces of the cuboid using vertex indices
    faces = [1, 2, 6, 5;  2, 3, 7, 6;  3, 4, 8, 7;  4, 1, 5, 8;  1, 2, 3, 4;  5, 6, 7, 8];
    
    % Plot the faces of the cuboid
    for i = 1:size(faces, 1)
        % Extract the points of the current face
        face_points = points(faces(i, :), :);
        
        % Plot the face as a semi-transparent polygon
        fill3(face_points(:, 1), face_points(:, 2), face_points(:, 3), gray, 'FaceAlpha', 0.5);
    end
    
    % Optionally plot the camera if specified
    if camera ~= 0
        camera_plotter(cameraRotation, cameraPosition)
    end 
    
    % Configure the 3D plot
    xlabel('X-axis'); 
    ylabel('Y-axis'); 
    zlabel('Z-axis'); 
    axis equal;
    grid on;
    hold off;
end