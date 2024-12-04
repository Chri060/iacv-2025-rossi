% =================================================================
%                         Height estimation
% =================================================================

% Import utils 
addpath('iacv_homework\utils');


% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Import the calibration matrix 
calibration = load('iacv_homework\variables\calibration.mat');
K = calibration.K;