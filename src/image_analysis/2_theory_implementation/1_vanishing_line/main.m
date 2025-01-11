% ========================================================================= 
%   Vanishing line
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('images\scene.jpg');

% Import the variables
scene = load('variables\scene.mat');
lines = scene.lines;


%% Width vanishing point
% Select the lines l2 and l3 from the matrix lines
l2 = lines(1, :);
l3 = lines(3, :);

% Find the intersection point of l2 and l3
pl = lines_intersection(l2, l3);


%% Depth vanishing point
% Select the lines m5 and m6 from the matrix lines
m5 = lines(8, :);
m6 = lines(9, :);

% Find the intersection point of m5 and m6
pm = lines_intersection(m5, m6);


%% Height vanishing point
% Select the lines h1 and h4 from the matrix lines
h1 = lines(10, :);
h4 = lines(13, :);

% Find the intersection point of the two lines, that is the vanishing point
ph = lines_intersection(h1, h4);


%% Find the line at the infinity 
% We can find the parameters of the line at the infinity by simply finding 
% the line that pass through the vanishing points
l_infty = points_to_line(pl, pm);


%% Plotting the image
points = [pl;  pm;  ph];
lines = [l2;  l3;  m5;  m6;  h1;  h4;  l_infty];
image_plotter(img, points, lines, 1);


%% Printing the results
disp("The length vanishing point coordinates are: [x = " + pl(1) + ", y = " + pl(2) + ", w = " + pl(3) + "]")
disp("The depth vanishing point coordinates are: [x = " + pm(1) + ", y = " + pm(2) + ", w = " + pm(3) + "]")
disp("The height vanishing point coordinates are: [x = " + ph(1) + ", y = " + ph(2) + ", w = " + ph(3) + "]")
disp("The horizontal vanishing line parameters are: [a = " + l_infty(1) + ", b = " + l_infty(2)+ ", c = " + l_infty(3) + "]")


%% Saving the variables
save('variables\vanishing.mat', 'l_infty', 'pl', 'pm', 'ph');