% ========================================================================= 
%   Rectification
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
im = imread('images\scene.jpg');

% Import the variables 
vanishing = load('variables\vanishing.mat');
l_infty = vanishing.l_infty;
pl = vanishing.pl;
pm = vanishing.pm;
curves = load('variables\curves.mat');
curve = curves.C;


%% Compute the ellipse parameters
% Extract coefficients from the conic matrix
A  = curve(1,1);
B = 2 * curve(1,2);
C = curve(2,2); 
D = 2 * curve(1,3);
E = 2 * curve(2,3);
F = curve(3,3);

[ellipse, code] = matrix_to_geometric([A,B,C,D,E,F]);
% The conic equation is represented in 2D space as:
% A*x^2 + B*xy + C*y^2 + D*x + E*y + F = 0
figure; 
imshow(im);
ellipse = drawellipse('Center',ellipse.Center,'SemiAxes',ellipse.SemiAxes,'RotationAngle',ellipse.RotationAngle);


%% Create and apply a homography for rectification
% Normalize the line at infinity to make the third component equal to 1
l_infty = l_infty ./ l_infty(3);

% Construct the affine homography matrix
% This maps the line at infinity to [0; 0; 1] in homogeneous coordinates
H_aff = [1, 0, 0;  0, 1, 0;  l_infty];

% Apply the homography to the entire image
tform = projective2d(H_aff');
img_size = imref2d(10 * size(im));
img_aff = imwarp(im, tform, 'OutputView', img_size, 'FillValues', 255);

% Display the rectified image using a custom plotting function
image_plotter(img_aff, [], [], 0);


%% Convert ellipse parameters into a conic matrix and intersect with the vanishing line
% Extract geometric parameters of the ellipse
par_geo = [ellipse.Center, ellipse.SemiAxes, -ellipse.RotationAngle]';

% Convert geometric parameters to algebraic form (conic parameters)
par_alg = geometric_to_algebraic(par_geo);

% Unpack the conic parameters
[a1, b1, c1, d1, e1, f1] = deal(par_alg(1), par_alg(2), par_alg(3), par_alg(4), par_alg(5), par_alg(6));

% Construct the conic matrix for the ellipse
C1 = [a1, b1/2, d1/2;  b1/2, c1, e1/2;  d1/2, e1/2, f1];
C1 = C1 ./ C1(3, 3);

% Define symbolic variables for solving equations
syms x y;

% The ellipse is represented by the 2nd-degree conic equation:
eq1 = a1 * x^2 + b1 * x * y + c1 * y^2 + d1 * x + e1 * y + f1 == 0;

% The vanishing line is represented by:
eq2 = l_infty(1) * x + l_infty(2) * y+ l_infty(3) == 0;

% Solve the system of equations formed by the ellipse and the vanishing line
eqns = [eq1, eq2];
S12 = solve(eqns, [x,y]);

% hence you get 2 pairs of complex conjugate solution
II = [double(S12.x(1)); double(S12.y(1)); 1];
JJ = [double(S12.x(2)); double(S12.y(2)); 1];

% Define the homography matrix for mapping the vanishing line
H = [eye(2), zeros(2,1);  l_infty];

% Transform the conic matrix using the homography
Q = inv(H)'*C1*inv(H);
Q = Q./Q(3,3);


%% convert the conic coefficient to geometric parameters
% Extract coefficients from the conic matrix Q
conic_coeffs = [Q(1,1), 2*Q(1,2), Q(2,2), 2*Q(1,3), 2*Q(2,3), Q(3,3)];

% Convert the algebraic parameters into geometric parameters
par_geo = matrix_to_geometric(conic_coeffs);

% Extract geometric parameters from the structure
center = par_geo.Center;
axes = par_geo.SemiAxes;
angle = par_geo.RotationAngle;


%% Compute the affinity to make the axes of the ellipse equal
% The affinity transformation consists of a rotation, scaling, and inverse rotation
alpha = angle;
a = axes(1);
b = axes(2);

% Define the rotation matrix
U = [cos(alpha), -sin(alpha);  sin(alpha), cos(alpha)];

% Rescale the ellipse to make its axes unitary
S = diag([1, a/b]);

% Combine rotation and scaling
K = U * S * U';

% Extend K to 3x3 by adding a homogeneous row and column
A = [K zeros(2, 1);  zeros(1, 2), 1];

% The final transformation maps the image of the line at infinity to its canonical position
T = A * H;

%% Apply the transformation to the image
% Create a projective transformation object using the final transformation matrix
tform = projective2d(T');

% Apply the transformation to the image
img_rect = imwarp(im,tform, 'OutputView', img_size);

% Display the rectified image
image_plotter(img_rect,[],[],0);


%% Compute the homography and apply it to points and lines
% Select points in homogeneous coordinates
p1 = [1280; 9804; 1];
p2 = [160; 5631; 1];
p3 = [12145; 3775; 1];

% Compute lines passing through pairs of points
l1 = points_to_line(p2, p1);
l2 = points_to_line(p2, p3);

% Plot the rectified image with the computed lines overlaid
lines = [l1';l2'];
image_plotter(img_rect, [], lines, 0);


%% Compute dimensions of the plane
% The length corresponds to the Euclidean distance between points p2 and p3
length = norm(p2 - p3);

% The depth corresponds to the Euclidean distance between points p1 and p2
depth = norm(p1 - p2);

% Assuming the real-world width of the plane is 1, compute the depth-to-width ratio
real_depth =  depth / length;

% The angle between the lines should approximate 90 degrees after rectification
angle = 90 - angle_between_lines(l2, l2);

%% Display the homography matrix and computed dimensions
H_aff = H_aff';
H = T;
disp("The homography matrix is: ");
disp(H);
disp("The ratio between width and length is: " + real_depth);
disp("The angle between width and length is: " + angle);


%% Saving the variables
save('variables\rectification.mat', 'H', 'real_depth');