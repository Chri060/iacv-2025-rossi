% =======================================================================
%                         Vertical reconstruction
% =======================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\scene.jpg');

% Import the variables 
calibration = load('iacv_homework\variables\calibration.mat');
K = calibration.K;
omega = calibration.IAC;
vanishing = load('iacv_homework\variables\vanishing.mat');
ph = vanishing.ph; 
pm = vanishing.pm; 
pl = vanishing.pl; 
scene = load('iacv_homework\variables\scene.mat');
scene_points = scene.points;


%% Computation of useful variables
l_infty = points_to_line(ph, pl);


%% Intersection between the Image of the Absolute Conic and the line at the infinity
% System variables
syms x y;

% Equation for the Image of the Absolute Conic
eq1 = omega(1, 1) * x^2 + 2 * omega(1, 2) * x * y + omega(2, 2) * y^2 + 2 * omega(1, 3) * x + 2 * omega(2, 3) * y + omega(3, 3) == 0;

% Equation for the line at the infinity
eq2 = l_infty(1) * x + l_infty(2) * y + l_infty(3) == 0;

% System definition and solution
eqns = [eq1, eq2];
sol = solve(eqns, [x, y]);

% Intersection points (image of circular points
I = [double(sol.x(1));  double(sol.y(1));  1];
J = [double(sol.x(2));  double(sol.y(2));  1];


%% Homography computation
% Definition of the image of the dual conic
imDCCP = I * J' + J * I';
imDCCP = imDCCP ./ norm(imDCCP);

% Compute the homography by forcing the imDCCP to the canonical poistion
[U, D, V] = svd(imDCCP);
D(3, 3) = 1;
H = inv(U * sqrt(D));

% Applying the homography to the image
tform = projective2d(H');
img_mod = imwarp(img, tform, 'FillValues', 255); 
img_mod = imrotate(img_mod, -135);


%% Height computation
% Load the points from a variable
p1 = [809, 2805, 1]';
p3 = [2350, 2417, 1]';
p2 = [2379, 2789, 1]';


% compute the lines passing through the points
l1 = points_to_line(p1, p2);
l2 = points_to_line(p2, p3);

% Compte the relative width and height
lenght= norm (p1 - p2); 
height  = norm (p2 - p3); 

% Compare width and height to find the real height
real_height = height / lenght;
angle = angle_between_lines(l1, l2);


%% Image plotting
points = [p1';p2';p3'];
lines = [l1'; l2'];
image_plotter(img_mod, points, lines, 1)


%% Printing the results
disp("The circular point I coordinates are: [x = " + I(1) + ", y = " + I(2) + ", w = " + I(3) + "]")
disp("The circular point J coordinates are: [x = " + J(1) + ", y = " + J(2) + ", w = " + J(3) + "]")
disp("The image of the dual conic matrix is: "); 
disp(imDCCP);
disp("The homography matrix is: "); 
disp(H);
disp("The real height is: " + real_height);
disp("The angle between the lines is: " + angle);


%% Saving the image
imwrite(img_mod, 'iacv_homework\images\height.jpg');


%% Saving the variables
save('iacv_homework\variables\height.mat', 'H', 'real_height');