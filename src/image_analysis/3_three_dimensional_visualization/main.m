% ====================================================================
%                             Localization
% ====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the variables 
calibration = load('iacv_homework\variables\calibration.mat');
K = calibration.K;
localization = load('iacv_homework\variables\localization.mat');
object_vertices = localization.object_vertices;
R = localization.cameraRotation;
T = localization.cameraPosition;
cameraRotation = localization.cameraRotation;
cameraPosition = localization.cameraPosition;
tform_metric_to_world = localization.tform;
curves = load('iacv_homework\variables\curves.mat');
S = curves.S;
rectification = load('iacv_homework\variables\rectification.mat');
tform_image_to_metric = rectification.tform;
height = load('iacv_homework\variables\height.mat');
height = height.real_height * 1000;
S_points = load('iacv_homework\variables\S.mat');
image_points = S_points.points;


%% Plot of the actual parallelepiped with a camera


% Homogenize the 2D points
num_points = size(image_points, 1);
homogeneous_image_points = image_points'; % 3xN matrix

% Step 1: Back-project points to a ray in the camera frame
inv_K = inv(K);
camera_rays = inv_K * homogeneous_image_points; % 3xN rays (normalized directions)

% Step 2: Solve for Z_camera using the height constraint
world_points = zeros(3, num_points); % Allocate space for 3D world points
for i = 1:num_points
    % Extract the ray direction
    ray = camera_rays(:, i); % [X_camera; Y_camera; 1]
    
    % Camera extrinsics
    R2 = R(2, :); % Second row of rotation matrix
    T2 = T(2);    % Second component of translation vector
    
    % Solve for Z_camera using the height constraint
    Z_camera = (height - T2) / (R2 * ray); % Depth along the ray
    
    % Compute the full camera frame point
    camera_point = Z_camera * ray; % [X_camera; Y_camera; Z_camera]
    
    % Transform to the world frame
    world_point = R' * (camera_point - T); % Inverse extrinsic transformation
    world_points(:, i) = world_point;
end

% Optional: Transform from metric frame to world frame
if exist('tform_image_to_metric', 'var') && ~isempty(tform_image_to_metric)
    metric_points_2D = transformPointsForward(tform_image_to_metric, world_points(1:2, :)'); % Apply metric transformation
    metric_points_3D = [metric_points_2D'; world_points(3, :)]; % Reattach Z (depth)
    
    if exist('tform_metric_to_world', 'var') && ~isempty(tform_metric_to_world)
        world_points_2D = transformPointsForward(tform_metric_to_world, metric_points_3D(1:2, :)'); % Apply world transformation
        world_points = [world_points_2D'; metric_points_3D(3, :)]; % Final 3D world points
    else
        world_points = metric_points_3D; % Skip if no world transformation is provided
    end
end

% Display the 3D world points



for k = 1 : 12 
    world_points(2, k) = height / 2;
end
world_points(1, :) = -world_points(1, :);

disp('3D World Points:');
disp(world_points');

object_plotter(object_vertices, 1, cameraRotation, cameraPosition, world_points')

