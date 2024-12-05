% ========================================================================
%                         Circumference estimation
% ========================================================================

% Import utils 
addpath('iacv_homework\utils');


% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\metric.jpg');


%% Import the points estimated in the original image 
points = load('iacv_homework\variables\points.mat');
p1 = [3039; 4346; 1];
p2 = [2914; 4460; 1];
p3 = [3251; 4426; 1];
p4 = [3150; 4369; 1];
p5 = [2939; 4524; 1];

P = [p1';p2';p3';p4';p5'];

[xc, yc, radius] = points_to_circle(P);












figure;
imshow(img);
hold on;
impixelinfo;
viscircles([xc, yc], radius, 'EdgeColor', 'r');
title('Fitted Circle on the Jar');