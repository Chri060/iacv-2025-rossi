% ====================================================================
%                             Localization
% ====================================================================

% Import utils 
addpath('iacv_homework\utils');


% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');

% Import the variables 
scene = load('iacv_homework\variables\scene.mat');
points = scene.points;
rectification = load('iacv_homework\variables\rectification.mat');
H_aff = rectification.H_rect';
H_met = rectification.H_met; 
calibration = load('iacv_homework\variables\calibration.mat');
K = calibration.K;