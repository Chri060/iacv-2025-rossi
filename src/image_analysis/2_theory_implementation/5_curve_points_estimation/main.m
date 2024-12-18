% =====================================================================
%                        Curve points estimation
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the variables 
curves = load('iacv_homework\variables\curves.mat');
S = curves.S;


%% Find some points of the curve
% Select the number of points desired
number_of_points = 12;

% Find some random points in the curve S
points = generateConicPoints(img, S, number_of_points);

% Transform all points in homogeneous coordinates
points = [points;  ones(1, 12)];


%% Printing the results
for k = 1 : size(points, 2)
    disp("The set of coordinate for point " + k + " is: ")
    disp(points(:, k));
end 