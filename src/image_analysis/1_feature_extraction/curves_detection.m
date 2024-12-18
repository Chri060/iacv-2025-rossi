% ======================================================================
%                            Curves detection
% ======================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\scene.jpg');

% Import the variables
scene = load('iacv_homework\variables\scene.mat');
curves_points = scene.curves_points;


%% Estimation of C
% Import the points extracted with lines_detection.m
C_points = [
    curves_points(1, 1), curves_points(1, 2), 1; 
    curves_points(2, 1), curves_points(2, 2), 1; 
    curves_points(3, 1), curves_points(3, 2), 1; 
    curves_points(4, 1), curves_points(4, 2), 1; 
    curves_points(5, 1), curves_points(5, 2), 1; 
];

% Plot the image with the found points
lines = [];
points = C_points;
image_plotter(img, points, lines, 1);

% Extract the x and y coordinates from C_points
x = C_points(:, 1); 
y = C_points(:, 2); 

% Build the design matrix A that represents the system of equations
% for the conic in the general form Ax^2 + By^2 + Cxy + Dx + Ey + F = 0
A = [x.^2, x.*y, y.^2, x, y, ones(size(x))];

% To solve for the conic parameters, we need the Right Null Space of A
% which represents the coefficients of the conic.
[~, ~, V] = svd(A); 
N = V(:, end);

% The matrix N contains the parameters for the conic equation
cc = N(:, 1);

% Rename the parameters for clarity
[a, b, c, d, e, f] = deal(cc(1), cc(2), cc(3), cc(4), cc(5), cc(6));

% Define the conic matrix for the general conic equation
C = [ a, b/2, d/2;  b/2, c, e/2;  d/2, e/2, f];


%% Estimation of S
% Import the points extracted with lines_detection.m
S_points = [
    curves_points(6, 1), curves_points(6, 2), 1; 
    curves_points(7, 1), curves_points(7, 2), 1; 
    curves_points(8, 1), curves_points(8, 2), 1; 
    curves_points(9, 1), curves_points(9, 2), 1; 
    curves_points(10, 1), curves_points(10, 2), 1; 
];

% Plot the image with the found points
lines = [];
points = S_points;
image_plotter(img, points, lines, 1);

% Extract the x and y coordinates from S_points
x = S_points(:, 1); 
y = S_points(:, 2); 

% Build the design matrix A that represents the system of equations
% for the conic in the general form Ax^2 + By^2 + Cxy + Dx + Ey + F = 0
A = [x.^2 x.*y y.^2 x y ones(size(x))];

% To solve for the conic parameters, we need the Right Null Space of A
% which represents the coefficients of the conic
% For a better precision we use the SVD
[~, ~, V] = svd(A); 
N = V(:, end);

% The matrix N contains the parameters for the conic equation
cc = N(:, 1);

% Rename the parameters for clarity
[a, b, c, d, e, f] = deal(cc(1), cc(2), cc(3), cc(4), cc(5), cc(6));

% Define the conic matrix for the general conic equation
S = [a, b/2, d/2;  b/2, c, e/2;  d/2, e/2, f];


%% Plotting the conics
conics = [C;  S];
label_points = [curves_points(2, 1:2); curves_points(8, 1:2)];
labels = ['C';  'S'];
conic_plotter(img, conics, label_points, labels);


%% Saving the variables
save('iacv_homework\variables\curves.mat', 'C', 'S');