% =====================================================================
%                        Curve points estimation
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\scene.jpg');

% Import the variables 
curves = load('iacv_homework\variables\curves.mat');
S = curves.S;


%% Find some points of the curve
% Select the number of points desired
number_of_points = 12;
seed = 1234567890;

% Find some random points in the curve S
points = generate_conic_points(img, S, number_of_points, seed);

% Transform all points in homogeneous coordinates
points = [points;  ones(1, 12)]';


%% Plotting the image
image_plotter(img, points, [], 1); 


%% Printing the results
for k = 1 : size(points, 2)
    disp("The set of coordinate for point " + k + " is: ")
    disp(points(:, k));
end 


%% Saving the variables
save('iacv_homework\variables\S.mat', 'points');