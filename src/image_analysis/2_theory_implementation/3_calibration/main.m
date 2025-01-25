% ========================================================================= 
%   Calibration
% ========================================================================= 

% Import utils 
addpath('utils');

% Clear all variables and close all
clear;
close all;

% Import the variables
vanishing = load('variables\vanishing.mat');
ph = vanishing.ph';
pl = vanishing.pl';
pm = vanishing.pm';
l_infty = vanishing.l_infty;
rectification = load('variables\rectification.mat');
H = rectification.H;


%% Normalize all variables
% Normalize points to ensure they are in homogeneous coordinates
pl = pl ./ pl(3);
ph = ph ./ ph(3);
pm = pm ./ pm(3);
l_infty = l_infty ./ l_infty(3);


%% Define the system
% Assume omega has the form [a 0 b; 0 1 c; b c d]
syms a b c d;

% Initialize omega matrix (Image of the Absolute Conic)
omega = [a, 0, b;  0, 1, c;  b, c, d];
   

%% Define the variables useful for the constraints
% Construct lx matrix based on l_infinity values
lx = [0, - l_infty(3), l_infty(2);  
      l_infty(3), 0, - l_infty(1);  
      -l_infty(2), l_infty(1), 0];  

% Extract columns of H for later use
H = inv(H);
h1 = H(:, 1);
h2 = H(:, 2);

    
%% Define the constraints
% First and second constraints: [l_infinity] × omega × ph = 0
eq1 = lx(1,:) * omega * ph == 0; 
eq2 = lx(2,:) * omega * ph == 0;

% Third constraint: pm' * omega * pl = 0
eq3 = pm.' * omega * pl == 0;

% Fourth constraint: h1' * omega * h1 = h2' * omega * h2
eq4 = h1.' * omega * h1 == h2.' * omega * h2;

% Fifth constraint 
eq5 = h1.' * omega * h2 == 0;


%% Solve the system
% Add these constraints to the equation list
eqn = [eq1, eq2, eq3, eq4, eq5];

% Cast equations into matrix form for solving
[A, y] = equationsToMatrix(eqn, [a, b, c, d]);

% Convert symbolic matrices to numeric format
X = double(A);
Y = double(y);

% Solve the system
W = X \ Y;

% Construct the Image of Absolute Conic (IAC) matrix
omega = double([W(1, 1), 0, W(2, 1);  0, 1, W(3, 1);  W(2, 1), W(3, 1), W(4, 1)]);


%% Compute the calibration matrix
% Extract intrinsic parameters from IAC
alfa = sqrt(omega(1, 1));
u0 = -omega(1, 3) / (alfa^2);
v0 = -omega(2, 3);
fy = sqrt(omega(3, 3) - (alfa^2) * (u0^2) - (v0^2));
fx = fy / alfa;

% Build K matrix using intrinsic parameters
K = [fx, 0, u0;  0, fy, v0;  0, 0, 1];


%% Printing the results
disp("The Image of The Absolute Conic matrix is: "); 
format long g;
disp(omega);
disp("The calibration matrix is: "); 
format long g;
disp(K);


%% Saving the calibration matrix
save('variables\calibration.mat', 'K', 'omega');