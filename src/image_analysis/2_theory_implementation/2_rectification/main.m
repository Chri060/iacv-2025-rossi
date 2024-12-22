% =====================================================================
%                             Rectification
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\scene.jpg');

% Import the variables 
vanishing = load('iacv_homework\variables\vanishing.mat');
l_infty = vanishing.l_infty;
scene = load('iacv_homework\variables\scene.mat');
lines = scene.lines; 
points = scene.points; 


%% Create and appy an homography for rectification
% Normalize the line with respect to the parameter c
l_infty = l_infty ./ l_infty(3);

% Create a homography to map the line at the infinity back to [0; 0; 1]
H_rect = [1, 0, 0;  0, 1, 0;  l_infty];

% Apply the image to the whole image
tform = projective2d(H_rect');
img_rect = imwarp(img, tform, 'OutputView', imref2d(10 * size(img)), 'FillValues', 255);


%% Plotting the image
% Display the rectified image
lines_rect = [];
points_rect = [];
image_plotter(img_rect, points_rect, lines_rect, 0);


%% Select two pairs of orthogonal lines used for the stratified method
% First pair of orthogonal lines
l2 = lines(2, :);
m5 = lines(8, :);

% Second pair of orthogonal lines
d1 = points_to_line(points(4, :), points(7,:));
d2 = points_to_line(points(3, :), points(8,:));

% Compute the transformation on the lines
H_points = inv(H_rect); 

l2_t = H_points' * l2';      
m5_t = H_points' * m5';
d1_t = H_points' * d1'; 
d2_t = H_points' * d2';

% Normalize transformed lines
l2_t = l2_t / l2_t(3);
m5_t = m5_t / m5_t(3);
d1_t = d1_t / d1_t(3);
d2_t = d2_t / d2_t(3);


%% Plotting the image
% Display the rectified image
lines_rect = [l2_t';  m5_t';  d1_t';  d2_t'];
points_rect = [];
image_plotter(img_rect, points_rect, lines_rect, 0);


%% Create the matrix A and apply SVD to find matrix S
A = [
    l2_t(1) * m5_t(1), l2_t(1) * m5_t(2) + l2_t(2) * m5_t(1), l2_t(2) * m5_t(2); 
    d1_t(1) * d2_t(1), d1_t(1) * d2_t(2) + d1_t(2) * d2_t(1), d1_t(2) * d2_t(2);
];

% Perform Singular Value Decomposition on matrix A
[~, ~, v] = svd(A);

% Select the last row of the matrix v
s = v(:, end);

% Construct the matrix S with the elements of the vector s
S = [s(1), s(2); s(2), s(3)];


%% Compute the rectifying homography
% Perform Singular Value Decomposition on matrix S
[U, D, V] = svd(S);

% Reconstruct matrix G using U, D, and V from SVD
% The square root of D ensures the matrix satisfies geometric constraints
G = U * sqrt(D) * V';

% Initialize a 3x3 identity matrix H and and assign elements of matrix A to 
% the transformation matrix H
H_met = eye(3); 
H_met(1,1) = G(1,1);
H_met(1,2) = G(1,2);
H_met(2,1) = G(2,1);
H_met(2,2) = G(2,2);

% Compute the rectification transformation matrix
H_met = inv(H_met);

% Create a projective 2D transformation object using H and apply the 
% projective transformation to the input image
H = H_met * H_rect;
tform = projective2d(H');
img_met = imwarp(img, tform, 'OutputView', imref2d(10 * size(img)), 'FillValues', 255);


%% Compute the homography and apply to the points and the lines 
% Select the points
p1 = [points(15,1); points(15,2); 1];
p2 = [points(11,1); points(11,2); 1];
p3 = [points(14,1); points(14,2); 1];

% Select the lines 
l2 = lines(2, :);
m5 = lines(8, :);

% Compute the transformed points and normalize
p1 = H * p1; 
p2 = H * p2;
p3 = H * p3;
p1 = p1 ./ p1(3);
p2 = p2 ./ p2(3);
p3 = p3 ./ p3(3);

% Compute the transformed lines
H_lines = inv(H)'; 
l2 = H_lines * l2'; 
m5 = H_lines * m5';


%% Plotting the image
points_met = []; 
lines_met = []; 
image_plotter(img_met, points_met, lines_met, 0); % img_met


%% Compute the dimensions of the plane 
length = norm(p2 - p3);
depth = norm(p1 - p2);


%% Compute the real depth
% We know that the real width is one
real_depth =  depth / length;


%% Compute the angle between the lines identified by the points
% The angle between the lines must be near 90 degrees 
angle = angle_between_lines(l2, m5);


%% Saving the images
imwrite(img_rect, 'iacv_homework\images\rectified.jpg');
imwrite(img_met, 'iacv_homework\images\metric.jpg');


%% Printing the results
disp("The rectification matrix is: ");
disp(H_rect);
disp("The metric rectification matrix is: ");
disp(H_met);
disp("The ratio between width and length is: " + real_depth);
disp("The angle between width and length is: " + angle);


%% Saving the variables
save('iacv_homework\variables\rectification.mat', 'H_rect', 'H_met', 'H', 'real_depth');