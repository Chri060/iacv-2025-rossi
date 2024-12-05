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


%% Import the calibration matrix and the vanishing points
calibration = load('iacv_homework\variables\calibration.mat');
K = calibration.K;

vanishing = load('iacv_homework\variables\vanishing.mat');

% Vanishing points for the height and the width
ph = vanishing.ph; 
pl = vanishing.pl; 

l_infty = points_to_line(ph(1), ph(2), pl(1), pl(2));

omega = inv(K * K');

% setting the system variables
syms 'x';
syms 'y';



% equation of the image absolute conic
eq1 = omega(1,1)*x^2 + 2*omega(1,2)*x*y + omega(2,2)*y^2 + 2*omega(1,3)*x + 2*omega(2,3)*y + omega(3,3);

% equation of the image of the line at the infinity
eq2 = l_infty(1)*x + l_infty(2) * y + l_infty(3);

% solving the system
eqns = [eq1 == 0, eq2 == 0];
sol = solve(eqns, [x,y]);

%solutions (image of circular points)
I = [double(sol.x(1));double(sol.y(1));1];
J = [double(sol.x(2));double(sol.y(2));1];

% image of dual conic
imDCCP = I*J' + J*I';
imDCCP = imDCCP./norm(imDCCP);

%compute the rectifying homography
[U,D,V] = svd(imDCCP);
D(3,3) = 1;
H = inv(U * sqrt(D));

% applying the homography to the image
tform = projective2d(H');
img = imwarp(img, tform);

% Image rotation for better visualization

img = imrotate(img, 148);


%% Height computation
points = load("iacv_homework\variables\height_points.mat"); 
points = points.points;

p1 = [points(1,1); points(1,2); 1];
p2 = [points(2,1); points(2,2); 1];
p3 = [points(3,1); points(3,2); 1];

heig = norm (p1 - p2); 
width = norm (p2 - p3); 




real_height = heig / width;



% plotting the final outcome
fig = figure();

imshow(img); 
hold on;
point_plotter(p1, 'r.');
point_plotter(p2, 'r.');
point_plotter(p3, 'r.');
line_plotter(l_infty, 0, 10000, 'g-')

hold off;

%% Save the image 
imwrite(img, 'iacv_homework\images\height.jpg');