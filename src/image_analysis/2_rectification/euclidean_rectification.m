% =====================================================================
%                        Euclidean rectification
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Importing the vanishing line
% Import the vanishing line values
vanishing = load('iacv_homework\variables\vanishing.mat');
l_infty = vanishing.l_infty;

% Normalize the line with respect to the parameter c
l_infty = l_infty ./ l_infty(3);


%% Homography and rectification
% Create a homography to map the line at the infinity back to [0; 0; 1]
H = [1,0,0; 
     0,1,0;
     l_infty(:)'];

% Apply the image to the whole image
tform = projective2d(H');
rectified_img = imwarp(img, tform, 'OutputView', imref2d(9 * size(img)));


%% Image plotting
% Display the rectified image
figure;
imshow(rectified_img);


%% Save the rectified image
% The image is called rectified.jpg
imwrite(rectified_img, 'iacv_homework\images\rectified.jpg');

% Save the homography matrix
save('iacv_homework\variables\rectification.mat', 'H');