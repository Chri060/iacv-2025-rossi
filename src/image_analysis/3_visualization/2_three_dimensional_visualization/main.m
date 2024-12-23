% =========================================================================
%                  Three dimensional visualization
% =========================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\scene.jpg');

% Import the variables 
S_points = load('iacv_homework\variables\S.mat');
points = S_points.points;
rectification = load('iacv_homework\variables\rectification.mat');
H_met = rectification.H_met;
H_aff = rectification.H_rect;


%% Perform a metric rectification on the image and S points
H = H_met * H_aff;
tform = projective2d(H');
img_met = imwarp(img, tform, 'OutputView', imref2d(10 * size(img)), 'FillValues', 255);
transformed_points = transformPointsForward(tform, points(:,1:2));

% Plot the image with the points 
image_plotter(img_met, transformed_points, [], 0)

% Extract the conic matrix
S_met = conic_extractor(transformed_points);


%% Plotting the final conic
conic_plotter(img_met, S_met, [2640,1275], 'S', 1);