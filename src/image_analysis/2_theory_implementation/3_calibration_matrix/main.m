% =================================================================
%                            Calibration
% =================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the variables
vanishing = load('iacv_homework\variables\vanishing.mat');
ph = vanishing.ph;
pl = vanishing.pl;
pm = vanishing.pm;
rectification = load('iacv_homework\variables\rectification.mat');
H_met = rectification.H_met;
H_aff = rectification.H_rect;


%% Estimate calibration matrix K
van_points = [ph(1:2); pl(1:2); pm(1:2)];
[IAC, K] = calibration_compute(van_points, H_aff * H_aff');


%% Printing the results 
disp("The calibration matrix is: "); 
format long g;
disp(K);


%% Saving the calibration matrix
save('iacv_homework\variables\calibration.mat', 'K', 'IAC');