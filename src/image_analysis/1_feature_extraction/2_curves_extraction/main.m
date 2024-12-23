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

C = conic_extractor(C_points);


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

S = conic_extractor(S_points);


%% Plotting the conics
conics = [C;  S];
label_points = [curves_points(2, 1:2); curves_points(8, 1:2)];
labels = ['C';  'S'];
conic_plotter(img, conics, label_points, labels, 2);


%% Saving the variables
save('iacv_homework\variables\curves.mat', 'C', 'S');