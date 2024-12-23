% =========================================================================
%   Three dimensional visualization
% =========================================================================

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the variables 
localization = load('variables\localization.mat');
object_vertices = localization.object_vertices;
cameraRotation = localization.cameraRotation;
cameraPosition = localization.cameraPosition;


%% Plotting the three-dimensional view of the camera and object
object_plotter(object_vertices, 1, cameraRotation, cameraPosition)
