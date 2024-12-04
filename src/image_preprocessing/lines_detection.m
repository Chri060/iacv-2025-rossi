% =====================================================================
%                            Lines detection
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;


% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Edge detection with Canny
img_gray = rgb2gray(img);
edges = edge(img_gray, 'Canny', [0.0125 0.0312]);


%% Hough Transformation to find the lines
% Hough Transformation space
[H, theta, rho] = hough(edges);

% Hough peaks for line detection
peaks = houghpeaks(H, 50, 'threshold', ceil(0.3*max(H(:))));

% Line formatting through Hough Transformation
lines = houghlines(edges, theta, rho, peaks, 'FillGap', 1000, 'MinLength', 500);


%% Image plotting
% Create a figure for displaying the image
fig = figure();
imshow(img), hold on

% For each line detected, plot and label it
for k = 1:length(lines)
    l = points_to_line(lines(k).point1(1), lines(k).point1(2), lines(k).point2(1), lines(k).point2(2));
    line_plotter(l, lines(k).point1(1), lines(k).point2(1), 'r-');
    text(lines(k).point1(1), lines(k).point1(2), int2str(k), 'FontSize', 15, 'Color', 'white'); 
end
title('Lines Detected');


%% Save useful variables inside a file 
save('iacv_homework\variables\lines.mat', 'lines');