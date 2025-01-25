% ========================================================================= 
%   Rectification
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('images\scene.jpg');

% Import the variables 
vanishing = load('variables\vanishing.mat');
l_infty = vanishing.l_infty;
pl = vanishing.pl;
pm = vanishing.pm;
curves = load('variables\curves.mat');
C = curves.C;


%% Create and apply a homography for rectification
% Construct the affine homography matrix
% This maps the line at infinity to [0; 0; 1] in homogeneous coordinates
H_aff = [1, 0, 0;  0, 1, 0;  l_infty];

% Apply the homography to the entire image
tform = projective2d(H_aff');
img_size = imref2d(10 * size(img));
img_aff = imwarp(img, tform, 'OutputView', img_size, 'FillValues', 255);

% Display the rectified image using a custom plotting function
image_plotter(img_aff, [], [], 0);


%% 
%Apply the affine homography to the curve
Q = inv(H_aff)' * C * inv(H_aff);
Q = Q ./ Q(3,3);


%% convert the conic coefficient to geometric parameters
% Extract coefficients from the conic matrix Q
a = Q(1, 1);
b = 2 * Q(1, 2);
c = Q(2, 2); 
d = 2 * Q(1, 3);
e = 2 * Q(2, 3);
f = Q(3, 3);

% Convert the algebraic parameters into geometric parameters
par_geo = matrix_to_geometric([a, b, c, d, e, f]);


%% Compute the affinity to make the axes of the ellipse equal
% The affinity transformation consists of a rotation, scaling, and inverse rotation
alpha = par_geo.RotationAngle;
a = par_geo.SemiAxes(1);
b = par_geo.SemiAxes(2);

% Define the rotation matrix
R = [cos(alpha), -sin(alpha);  sin(alpha), cos(alpha)];

% Rescale the ellipse to make its axes unitary
S = diag([1, a/b]);

% Combine rotation and scaling
H_red = R * S * R';

% Extend K to 3x3 by adding a homogeneous row and column
H_met = [H_red, zeros(2, 1);  zeros(1, 2), 1];

% The final transformation maps the image of the line at infinity to its canonical position
H = H_met * H_aff;


%% Apply the transformation to the image
% Create a projective transformation object using the final transformation matrix
tform = projective2d(H');

% Apply the transformation to the image
img_rect = imwarp(img, tform, 'OutputView', img_size, 'FillValues', 255);

% Display the rectified image
image_plotter(img_rect, [], [], 0);


%% Compute the homography and apply it to points and lines
% Select points in homogeneous coordinates
p1 = [1280;  9804;  1];
p2 = [160;  5631;  1];
p3 = [12145;  3775;  1];

% Compute lines passing through pairs of points
l1 = points_to_line(p2, p1);
l2 = points_to_line(p2, p3);


%% Compute dimensions of the plane
% The length corresponds to the Euclidean distance between points p2 and p3
length = norm(p2 - p3);

% The depth corresponds to the Euclidean distance between points p1 and p2
depth = norm(p1 - p2);

% Assuming the real-world width of the plane is 1, compute the depth-to-width ratio
real_depth = depth / length;

% The angle between the lines should approximate 90 degrees after rectification
angle = 90 - angle_between_lines(l2, l2);


%% Display the homography matrix and computed dimensions
disp("The affine homography matrix is: ");
disp(H_aff');
disp("The homography matrix is: ");
disp(H);
disp("The ratio between width and length is: " + real_depth);
disp("The angle between width and length is: " + angle);


%% Saving the variables
save('variables\rectification.mat', 'H', 'real_depth');