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
rectification = load('variables\rectification.mat');
H = rectification.H;
height = load('variables\height.mat');
H_fac = height.H;

%% Find some points of the curve
% Set the desired number of points to be sampled
number_of_points = 12;

% Generate some random points on the curve S
seed = 1234567890;

% Find some random points in the curve S
points = generate_conic_points(img, S, number_of_points, seed);

% Transform the points to homogeneous coordinates
points = [points;  ones(1, 12)]';

% Transform the points in the rectified image 
points_metric = zeros(number_of_points, 3);
for i = 1 : number_of_points 
    points_metric(i, :) = H * points(i, :)';
end


%% Metric rectification of the points
% Transform the image with the rectification
tform = projective2d(H');
img_rect = imwarp(img,tform, 'OutputView', imref2d(10 * size(img)), "FillValues", 255);


%% Vertical reconstruction of points
% Apply the homography to the image to perform metric rectification
tform = projective2d(H_fac');

% Apply the transformation to the image using imwarp with proper reference frame
[img_fac, R] = imwarp(img, tform, "FillValues", 255);

% Transform the points using the same homography
transformed_points_fac = transformPointsForward(tform, points(:,1:2));

% Adjust the reference frame
adjusted_points = bsxfun(@minus, transformed_points_fac, [R.XWorldLimits(1), R.YWorldLimits(1)]);


%% Plotting the image
% Plotting the origianl image
image_plotter(img, points, [], 0); 

% Plotting the rectified image
image_plotter(img_rect, points_metric, [], 0); 

% Plotting the reconstructed image
image_plotter(img_fac, adjusted_points, [], 0); 


%% Printing the results
points = points';
for k = 1 : size(points, 2)
    disp("The set of coordinate for point " + k + " is: ")
    disp(points(:, k));
end 
points_metric = points_metric';
for k = 1 : size(points, 2)
    disp("The set of coordinate for point " + k + " in metric rectification is: ")
    disp(points_metric(:, k));
end 


%% Saving the variables
points = points';
save('variables\S.mat', 'points');