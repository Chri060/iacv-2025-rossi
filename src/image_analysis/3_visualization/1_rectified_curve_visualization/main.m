% ========================================================================= 
%   Rectified curve visualization
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('images\scene.jpg');

% Import the variables 
S_points = load('variables\S.mat');
points = S_points.points;
rectification = load('variables\rectification.mat');
H_met = rectification.H_met;
H_aff = rectification.H_aff;


%% Perform a metric rectification on the image and S points
% Combine the homographies for metric rectification (H_met) and affine transformation (H_aff)
H = H_met * H_aff;

% Apply the homography to the image to perform metric rectification
tform = projective2d(H');

% Apply the transformation to the image using imwarp with proper reference frame
img_met = imwarp(img, tform, 'OutputView', imref2d(10 * size(img)), 'FillValues', 255);

% Transform the points using the same homography
transformed_points = transformPointsForward(tform, points(:,1:2));

% Plot the rectified image with transformed points overlaid
image_plotter(img_met, transformed_points, [], 0)


%% Extract the conic matrix from the transformed points
% Use a function to extract the conic matrix from the transformed points
S_met = conic_extractor(transformed_points);


%% Plotting the image
conic_plotter(img_met, S_met, [2640,1275], 'S', 1);