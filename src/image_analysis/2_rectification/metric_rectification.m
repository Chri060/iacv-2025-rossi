% ==================================================================
%                        Metric rectification
% ==================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\rectified.jpg');


%% Select two pairs of orthogonal lines used for the stratified method
% First pair of orthogonal lines
l = points_to_line(35, 1840, 845, 3604);
m = points_to_line(35, 1840, 6711, 2746);

% Insert the pair as a contraint in matrix A (first row) 
A(1,:) = [l(1) * m(1), l(1) * m(2) + l(2) * m(1), l(2) * m(2)];

% Second pair of orthogonal lines
l1 = points_to_line(114, 24, 721, 409);
m1 = points_to_line(261, 358, 574, 83);

% Insert the pair as a contraint in matrix A (second row)
A(2,:) = [l1(1) * m1(1), l1(1) * m1(2) + l1(2) * m1(1), l1(2) * m1(2)];

%% Solve the system to find the matrix S
% Perform Singular Value Decomposition on matrix A
[~,~,v] = svd(A);

% Select the last row of the matrix v
s = v(:,end);

% Construct the matrix S with the elements of the vector s
S = [s(1), s(2); 
     s(2), s(3)];

%% Compute the rectifying homography
% Create the image of the circular points matrix
% This matrix represents the ideal points for rectification
imDCCP = [S, zeros(2, 1); zeros(1, 3)]; % the image of the circular points

% Perform Singular Value Decomposition on matrix S
[U,D,V] = svd(S);

% Reconstruct matrix A using U, D, and V from SVD
% The square root of D ensures the matrix satisfies geometric constraints
A = U * sqrt(D) * V';

% Initialize a 3x3 identity matrix H and and assign elements of matrix A to 
% the transformation matrix H
H = eye(3); 
H(1:2, 1:2) = A(1:2, 1:2);

% Compute the rectification transformation matrix Hrect
H = inv(H);

% Create a projective 2D transformation object using H and apply the 
% projective transformation to the input image
tform = projective2d(H');
metric_image = imwarp(img,tform);


%% Image plotting
% Plot the metric rectified image
figure; 
hold on;
imshow(metric_image); 
hold off;


%% Save the rectified image
imwrite(metric_image, 'iacv_homework\images\metric.jpg');

% Save the metric homography matrix
save('iacv_homework\variables\metric.mat', 'H');