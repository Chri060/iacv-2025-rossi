% ========================================================================= 
%   Localization
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('images\scene.jpg');

% Import the variables 
scene = load('variables\scene.mat');
points = scene.points;
rectification = load('variables\rectification.mat');
H = rectification.H
real_depth = rectification.real_depth; 
calibration = load('variables\calibration.mat');
K = calibration.K;
height = load('variables\height.mat');
real_height = height.real_height;


%% Import and compute useful variables
% Points of the frontal facade of the object (coordinates from the image)
A = points(11, 1:2); % Left bottom point
B = points(1, 1:2);  % Left top point
C = points(2, 1:2);  % Right top point
D = points(14, 1:2); % Right bottom point

% Plot the selected points on the image for visualization
image_plotter(img, [A; B; C; D], [], 1)

% Apply the transformation to the selected points using the homography
tform = projective2d(H.');
[A(1), A(2)] = transformPointsForward(tform, A(1), A(2));
[B(1), B(2)] = transformPointsForward(tform, B(1), B(2));
[C(1), C(2)] = transformPointsForward(tform, C(1), C(2));
[D(1), D(2)] = transformPointsForward(tform, D(1), D(2));


%% Definition of the world reference frame
% Set the known dimension (length) of the object in the world frame
world_length = 1000;
world_height = world_length * real_height;
world_depth = world_length * real_depth;

% Coordinates of the real-world points in the world reference frame
real_points = [0, 0;  0, world_height;  world_length, world_height;  world_length 0];

% Coordinates of the points in the image frame after transformation
image_points = [A; B; C; D];


%% Computation of the homographies from world to image
% Find the homography that maps image points to real-world coordinates
tform = fitgeotrans(image_points, real_points, 'projective');
H_img_to_world = (tform.T).';

% Compute the homography from world frame to image frame
H_world_to_img = inv(H_img_to_world * H);


%% Computation of camera position and rotation
% Split the homography matrix into components
h1 = H_world_to_img(:,1);
h2 = H_world_to_img(:,2);
h3 = H_world_to_img(:,3);

% Compute normalization factor lambda (scaling factor)
lambda = 1 / norm(K \ h1);

% Compute the camera rotation matrix (R) from the columns of the homography
r1 = (K \ h1) * lambda;
r2 = (K \ h2) * lambda;
r3 = cross(r1, r2);

% Combine r1, r2, and r3 to form the rotation matrix R
R = [r1, r2, r3];

% Perform SVD to correct any numerical imprecisions and ensure R is orthogonal
[U, ~, V] = svd(R);
R = U * V';

% Rotation matrix definition (final orthogonalized rotation)
cameraRotation = R.';

% Compute the camera translation vector T (position of the camera in world frame)
T = (K \ (lambda * h3));

% Convert translation to the world frame using the rotation matrix
cameraPosition = - R.' * T;


%% Plotting the object
% Define the vertices of the object (parallelepiped) in world coordinates
object_vertices = [
    0 0 0; % A
    0 world_height 0 ; % B
    world_length world_height 0; % C
    world_length 0 0; % D
    0 0 -world_depth; % A back
    0 world_height -world_depth; % B back
    world_length world_height -world_depth; %C back
    world_length 0 -world_depth %D back
];

% Plot the object (parallelepiped) with the camera position and rotation
object_plotter(object_vertices, 1, cameraRotation, cameraPosition)


%% Printing the results
disp("The position of the camera is: [x = " + cameraPosition(1) + ", y = " + cameraPosition(2) + ", w = " + cameraPosition(3) + "]")
disp("The rotation of the camera is: "); 
disp(cameraRotation);


%% Saving the variables
save('variables\localization.mat', 'object_vertices', 'cameraRotation', 'cameraPosition');