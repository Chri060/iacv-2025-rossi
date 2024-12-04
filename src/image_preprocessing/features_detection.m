% =======================================================================
%                            Feature detection
% =======================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Apply MinEigen Features algorithm
% Find the relevant points in the image using MinEigen Features algorithm
% Better than Harris in this case since less sensitive to the image scale 
% and gradient information
points = detectMinEigenFeatures(rgb2gray(img));

% Show the image with the points found with the algorithm
imshow(img);
hold on;
plot(points);
title('MinEigen Features');


%% Save useful variables inside a file 
save('iacv_homework\variables\points.mat', 'lines');