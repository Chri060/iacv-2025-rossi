% =======================================================================
%                           Curve rectification
% =======================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the variables 
localization = load('iacv_homework\variables\localization.mat');
object_vertices = localization.object_vertices;
cameraRotation = localization.cameraRotation;
cameraPosition = localization.cameraPosition;


%% Plotting the three dimensional view of camera and object
object_plotter(object_vertices, 1, cameraRotation, cameraPosition)