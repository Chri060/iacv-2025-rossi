% ====================================================================
%                             Localization
% ====================================================================

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
H = localization.H_img_to_world;
curves = load('iacv_homework\variables\curves.mat');
S = curves.S;



%% Plot of the actual parallelepiped with a camera

S_prime = H' * S * H;  % Using H' for transpose of H


object_plotter(object_vertices, 1, cameraRotation, cameraPosition, S_prime)

