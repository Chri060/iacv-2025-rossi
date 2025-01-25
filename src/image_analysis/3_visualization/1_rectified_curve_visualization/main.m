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
H = rectification.H;
height = load('variables\height.mat');
H_fac = height.H;


%% Perform a metric rectification on the image and S points
% Apply the homography to the image to perform metric rectification
tform = projective2d(H');

% Apply the transformation to the image using imwarp with proper reference frame
img_met = imwarp(img, tform, 'OutputView', imref2d(10 * size(img)), 'FillValues', 255);

% Transform the points using the same homography
transformed_points = transformPointsForward(tform, points(:,1:2));


%% Perform the facade reconstruction on the image and S points 
% Apply the homography to the image to perform metric rectification
tform = projective2d(H_fac');

% Apply the transformation to the image using imwarp with proper reference frame
[img_fac, R] = imwarp(img, tform, 'FillValues', 255);

% Transform the points using the same homography
transformed_points_fac = transformPointsForward(tform, points(:,1:2));

adjusted_points = bsxfun(@minus, transformed_points_fac, [R.XWorldLimits(1), R.YWorldLimits(1)]);


%% Extract the conic matrix from the transformed points
% Use a function to extract the conic matrix from the transformed points
S_met = conic_extractor(transformed_points);
S_fac = conic_extractor(adjusted_points);


%% Plotting the images
conic_plotter(img_met, S_met, [2655,1374], "S", 1)
conic_plotter(img_fac, S_fac, [3233,1627], "S", 1)