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
l_infty = vanishing.l_infty;
rectification = load('iacv_homework\variables\rectification.mat');
H_met = rectification.H_met;
H_rect = rectification.H_rect';


%% Normalize all variables
pl = (pl ./ pl(3))';
ph = (ph ./ ph(3))';
pm = (pm ./ pm(3))';
l_infty = l_infty ./ l_infty(3);
H = inv(H_met * H_rect);


%% Define the system
% Assume omega has the form [a 0 b; 0 1 c; b c d]
syms a b c d;

% Initialize omega matrix (Image of the Absolute Conic)
omega = [a 0 b; 0 1 c; b c d];
   

%% Define the variables useful for the constraints
lx = [0, -l_infty(3), l_infty(2); l_infty(3), 0, -l_infty(1); -l_infty(2), l_infty(1), 0];  
h1 = H(:, 1);
h2 = H(:, 2);

    
%% Define the constraints
% First and second constraints: [l_infinity] × omega × ph = 0
eq1 = lx(1,:) * omega * ph == 0; 
eq2 = lx(2,:) * omega * ph == 0;

% Third constraint: pm' * omega * pl = 0
eq3 = pm.' * omega * pl == 0;

% Fourth constraint: h1' * omega * h2 = 0 
eq4 = h1.' * omega * h2 == 0;

% Fifth constraint: h1' * omega * h1 = h2' * omega * h2
eq5 = h1.' * omega * h1 == h2.' * omega * h2;


%% Solve the system
% Add these constraints to the equation list
eqn = [eq1, eq2, eq3, eq4, eq5];

% Cast equations into matrix form
[A, y] = equationsToMatrix(eqn, [a, b, c, d]);

% Convert the matrices to numeric format
X = double(A);
Y = double(y);

% Fit a linear model without intercept
lm = fitlm(X, Y, 'y ~ x1 + x2 + x3 + x4 - 1');
% Get the coefficients
W = lm.Coefficients.Estimate;

% Image of Absolute Conic
IAC = double([W(1,1) 0 W(2,1); 0 1 W(3,1); W(2,1) W(3,1) W(4,1)]);


%% Compute the calibration matrix
alfa = sqrt(IAC(1,1));
u0 = -IAC(1,3)/(alfa^2);
v0 = -IAC(2,3);
fy = sqrt(IAC(3,3) - (alfa^2)*(u0^2) - (v0^2));
fx = fy / alfa;

% Build K using the parameters
K = [fx 0 u0; 0 fy v0; 0 0 1];


%% Printing the results 
disp("The calibration matrix is: "); 
format long g;
disp(K);


%% Saving the calibration matrix
save('iacv_homework\variables\calibration.mat', 'K', 'IAC');