% ====================================================================
%                             Localization
% ====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\scene.jpg');

% Import the variables 
scene = load('iacv_homework\variables\scene.mat');
points = scene.points;
rectification = load('iacv_homework\variables\rectification.mat');
H_aff = rectification.H_rect;
H_met = rectification.H_met; 
real_depth = rectification.real_depth; 
calibration = load('iacv_homework\variables\calibration.mat');
K = calibration.K;
height = load('iacv_homework\variables\height.mat');
real_height = height.real_height;


%% Import and compute useful variables
% Points of the frontal facade of the object
A = points(11, 1:2); % Left bottom point
B = points(1, 1:2);  % Left top point
C = points(2, 1:2);  % Right top point
D = points(14, 1:2); % Right bottom point

image_plotter(img, [A; B; C; D], [], 1)
% Computation of the homography for metric rectification
H = H_met * H_aff;

% Apply the transformation to the points selected before
tform = projective2d(H.');
[A(1), A(2)] = transformPointsForward(tform, A(1), A(2));
[B(1), B(2)] = transformPointsForward(tform, B(1), B(2));
[C(1), C(2)] = transformPointsForward(tform, C(1), C(2));
[D(1), D(2)] = transformPointsForward(tform, D(1), D(2));


%% Definition of the world reference frame
% Setting the known dimesion as 1000, and using the ratios found before
world_length = 1000;
world_height = world_length * real_height;
world_depth = world_length * real_depth;

% Coordinates of real points in the new reference frame
real_points = [0, 0;  0, world_height;  world_length, world_height;  world_length 0];

% Array with the points coordinates in the image
image_points = [A; B; C; D];


%% Computation of the homographies from world to image
% Find the homography from image frame to world frame
tform = fitgeotrans(image_points, real_points, 'projective');
H_img_to_world = (tform.T).';

% Find the homography from world frame to image frame
H_world_to_img = inv(H_img_to_world * H);


%% Computation of camera position and rotation
% Splitting of the homography matrix
h1 = H_world_to_img(:,1);
h2 = H_world_to_img(:,2);
h3 = H_world_to_img(:,3);

% Computation of the normalization factor lambda
lambda = 1 / norm(K \ h1);

% Computation of the columns of the rotation R
r1 = (K \ h1) * lambda;
r2 = (K \ h2) * lambda;
r3 = cross(r1, r2);

% Composition of the rotation matrix R
R = [r1, r2, r3];

% SVD decomposition for correction of eventual numerical imprecisions
% R becomes orthogonal for sure
[U, ~, V] = svd(R);
R = U * V';

% Rotation matrix definition
cameraRotation = R.';

% Compute translation vector T (position of the plane in the camera frame)
T = (K \ (lambda * h3));

% Convert translation to the world frame using the rotation matrix
cameraPosition = - R.' * T;


%% Plotting the object
% Definition of the parallelepiped vertices
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

% Plot of the actual parallelepiped with a camera
object_plotter(object_vertices, 1, cameraRotation, cameraPosition, [])


%% Printing the results
disp("The position of the camera is: [x = " + cameraPosition(1) + ", y = " + cameraPosition(2) + ", w = " + cameraPosition(3) + "]")
disp("The rotation of the camera is: "); 
disp(cameraRotation);


%% Saving the variables
save('iacv_homework\variables\localization.mat', 'object_vertices', 'cameraRotation', 'cameraPosition' , 'tform');