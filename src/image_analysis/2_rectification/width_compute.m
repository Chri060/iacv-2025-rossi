% ===============================================================
%                        Depth computation
% ===============================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\metric.jpg');


%% Compute the depth
% Select two point on the depth extremes of the lower side
x = [1210 ; 6976; 1];
y = [8721; 6145 ; 1];

% Compute the distance between the two points
depth = norm(x - y);


%% Compute the width
% Select two point on the width extremes of the lower side
x1 = [1210 ; 6976; 1]; % Same as x
y1 = [1522; 9671 ; 1];

% Compute the distance between the two points
width = norm(x1 - y1);


%% Compute the real depth
% We know that the real width is one
real_depth = (width * 1) / depth;


%% Compute the angle between the lines identified by the points
% Compute the line for the depth 
l = points_to_line(x(1), x(2), y(1), y(2));

% Compute the line for the depth
l1 = points_to_line(x1(1), x1(2), y1(1), y1(2));

% The angle between the lines must be near 90 degrees 
angle = angle_between_lines(l,l1);


%% Image plotting
% Display the metric rectified image with the identified points
fig = figure();
imshow(img); 
hold on;
impixelinfo;
% Plot the points for the width
point_plotter(x, 'r.')
point_plotter(y, 'r.')

% Plot the points for the depth
point_plotter(x1, 'r.') 
point_plotter(y1, 'r.')

hold off;