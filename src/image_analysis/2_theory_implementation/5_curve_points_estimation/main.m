% ========================================================================= 
%   Curve points estimation
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('images\scene.jpg');

% Import the variables 
curves = load('variables\curves.mat');
S = curves.S;


%% Find some points of the curve
% Set the desired number of points to be sampled
number_of_points = 12;

% Generate some random points on the curve S
seed = 1234567890;

% Find some random points in the curve S
points = generate_conic_points(img, S, number_of_points, seed);

% Transform the points to homogeneous coordinates
points = [points;  ones(1, 12)]';


%% Plotting the image
image_plotter(img, points, [], 1); 


%% Printing the results
points = points';
for k = 1 : size(points, 2)
    disp("The set of coordinate for point " + k + " is: ")
    disp(points(:, k));
end 


%% Saving the variables
points = points';
save('variables\S.mat', 'points');