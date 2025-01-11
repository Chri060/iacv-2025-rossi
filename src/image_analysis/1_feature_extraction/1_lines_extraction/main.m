% ========================================================================= 
%   Lines extraction                     
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('images\scene.jpg');


%% Edges detection
% Preprocess the image
grayImage = rgb2gray(img);                 % Convert to grayscale
smoothedImage = imgaussfilt(grayImage, 1); % Denoise with Gaussian

% Apply Canny edge detection
edges = edge(smoothedImage, 'Canny');


%% Apply Harris corner detection to the modified image
% Define the coordinates for the Region Of Interest (ROI)
x1 = 300;    % x-coordinate of the top-left corner
y1 = 230;    % y-coordinate of the top-left corner
x2 = 1445;   % x-coordinate of the bottom-right corner
y2 = 785;    % y-coordinate of the bottom-right corner

% Define the ROI using the coordinates
roi = [x1, y1, x2 - x1, y2 - y1]; 

% Detect the usefule features using Harris algorithm
points_harris = detectHarrisFeatures(edges, 'MinQuality', 0.001, 'FilterSize', 3, 'ROI',roi); 


%% Extract useful points for the analysis
points = [points_harris.Location(:, 1), points_harris.Location(:, 2)];
image_plotter(img, points, [], 0); 
% 4 7 3 8
% Select the useful points
points = [  
    ceil(points_harris.Location(340, 1)) - 1, ceil(points_harris.Location(340, 2)) - 1, 1; 
    ceil(points_harris.Location(5933, 1)) + 1, ceil(points_harris.Location(5933, 2)), 1;  
    ceil(points_harris.Location(460, 1)) - 1, ceil(points_harris.Location(460, 2)), 1; 
    ceil(points_harris.Location(2779, 1)), ceil(points_harris.Location(2779, 2)) - 2, 1; 
    ceil(points_harris.Location(4287, 1)) + 1, ceil(points_harris.Location(4287, 2)) - 1, 1; 
    ceil(points_harris.Location(5887, 1)) + 1, ceil(points_harris.Location(5887, 2)) + 1, 1; 
    ceil(points_harris.Location(845, 1)) - 2, ceil(points_harris.Location(845, 2)) - 1, 1; 
    ceil(points_harris.Location(2428, 1)) + 3, ceil(points_harris.Location(2428, 2)) - 2, 1; 
    ceil(points_harris.Location(3456, 1)), ceil(points_harris.Location(3456, 2)), 1; 
    ceil(points_harris.Location(5514, 1)), ceil(points_harris.Location(5514, 2)) - 2, 1; 
    ceil(points_harris.Location(2, 1)) - 4, ceil(points_harris.Location(2, 2)) + 1, 1; 
    ceil(points_harris.Location(2915, 1)) - 1, ceil(points_harris.Location(2915, 2)) + 1, 1; 
    ceil(points_harris.Location(4907, 1)) - 1, ceil(points_harris.Location(4907, 2)) + 1, 1; 
    ceil(points_harris.Location(6401, 1)) + 1, ceil(points_harris.Location(6401, 2)) + 4, 1; 
    ceil(points_harris.Location(556, 1)) + 3, ceil(points_harris.Location(556, 2)) , 1; 
    ceil(points_harris.Location(5081, 1)), ceil(points_harris.Location(5081, 2)), 1; 
];

% Select the points for the curves
curves_points = [
    ceil(points_harris.Location(560, 1)), ceil(points_harris.Location(560, 2)), 1; % C
    ceil(points_harris.Location(1273, 1)), ceil(points_harris.Location(1273, 2)), 1;
    ceil(points_harris.Location(2123, 1)), ceil(points_harris.Location(2123, 2)), 1;
    ceil(points_harris.Location(2413, 1)), ceil(points_harris.Location(2413, 2)), 1;
    ceil(points_harris.Location(2545, 1)), ceil(points_harris.Location(2545, 2)), 1;
    ceil(points_harris.Location(3042, 1)), ceil(points_harris.Location(3042, 2)), 1; % S
    ceil(points_harris.Location(3137, 1)), ceil(points_harris.Location(3137, 2)), 1;
    ceil(points_harris.Location(3330, 1)), ceil(points_harris.Location(3330, 2)), 1;
    ceil(points_harris.Location(3471, 1)), ceil(points_harris.Location(3471, 2)), 1;
    ceil(points_harris.Location(3505, 1)), ceil(points_harris.Location(3505, 2)), 1;
];

% Select the points for the lines
lines = [
    points_to_line(points(1, :), points(2, :));      % l1 (1)
    points_to_line(points(11, :), points(14, :));    % l2 (2)
    points_to_line(points(15, :), points(16, :));    % l3 (3)
    points_to_line(points(3, :), points(7, :));      % m1 (4)
    points_to_line(points(4, :), points(8, :));      % m2 (5)
    points_to_line(points(5, :), points(9, :));      % m3 (6)
    points_to_line(points(6, :), points(10, :));     % m4 (7)
    points_to_line(points(11, :), points(15, :));    % m5 (8)
    points_to_line(points(14, :), points(16, :));    % m6 (9)
    points_to_line(points(1, :), points(11, :));     % h1 (10)
    points_to_line(points(4, :), points(12, :));     % h2 (11)
    points_to_line(points(5, :), points(13, :));     % h3 (12)
    points_to_line(points(2, :), points(14, :));     % h4 (13)
]; 


%% Plotting the image
% Plot the image with the extracted lines and points
image_plotter(img, points, lines, 1); 


%% Saving the variables
save('variables\scene.mat', 'points', 'lines', 'curves_points');