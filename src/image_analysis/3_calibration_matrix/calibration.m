% =================================================================
%                            Calibration
% =================================================================

% Import utils 
addpath('iacv_homework\utils');


% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Import vanishing points aand line at the infinity previously computed
vanishing = load('iacv_homework\variables\vanishing.mat');

% Vanishing point for height, width, and depth
ph = vanishing.ph;
pl = vanishing.pl;
pm = vanishing.pm;

% Line at the infinity
l_infty = vanishing.l_infty;


%% Import the homography matrices and compute the overall transformation
affine = load('iacv_homework\variables\rectification.mat');
metric = load('iacv_homework\variables\metric.mat');

% Affine transformation matrix
H_aff = affine.H;

% Metric transformation matrix
H_met = metric.H; 

% Compute the overall homography
H = inv(H_met * H_aff);


%% Compute the image of the absolute conic and the intrinsic parameters
% Compute the image of the absolute conic using the function get_iac
IAC = get_iac(l_infty, ph, pl, pm, H);

% Compute the ratio between the focal lengths along the x and y axis
alfa = sqrt(IAC(1, 1));

% Compute the coordinates the principal point (optical center) in pixels
u0 = - IAC(1, 3) / (alfa^2);
v0 = - IAC(2, 3);

% Compute the focal lenghts along the y and the x axis, respectively
fy = sqrt(IAC(3, 3) - (alfa^2) * (u0^2) - (v0^2));
fx = fy / alfa;

% Construct the intrinsic camera calibration matrix K
K = [fx, 0,  u0; 
     0,  fy, v0; 
     0,  0,  1];

% Display the computed calibration matrix K
disp(K);


%% Save the calibration matrix in a file
% The file is called calibration.mat
save('iacv_homework\variables\calibration.mat', 'K');