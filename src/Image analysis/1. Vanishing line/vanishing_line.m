clear 
clearvars
clc

%% Depth vanishing point
% Consider four points for the width
% They are found using corners_finder.m and imported manually

% Construct a matrix to find the Right Null Space and consequently the
% parameters for the line that connects the points
al1 = [485; 259; 1];
bl1 = [1315; 379; 1];
Al1 = [al1'; bl1'];
ll1 = null(Al1, 'r');  

% Do the same for the other line
al3 = [572; 773; 1];
bl3 = [1060; 756; 1];
Al3 = [al3'; bl3'];
ll3 = null(Al3, 'r');  

% Find the intersection point of the two lines
Apl = [ll1'; ll3'];
pl = null(Apl, 'r');  

% Compute the terms needed to plot the lines
xl1 = linspace(0, 3366.4);  
yl1 = (-ll1(1)*xl1 - ll1(3)) / ll1(2);
xl4 = linspace(0, 3366.4);  
yl4 = (-ll3(1)*xl4 - ll3(3)) / ll3(2);

%% Depth vanishing point
% Construct a matrix to find the Right Null Space and consequently the
% parameters for the line that connects the points
am1 = [403; 250; 1];
bm1 = [437; 366; 1];
Am1 = [am1'; bm1'];
lm1 = null(Am1, 'r');  

% Do the same for the other line
am4 = [1291; 394; 1];
bm4 = [1313; 379; 1];
Am4 = [am4'; bm4'];
lm4 = null(Am4, 'r');  

% Find the intersection point of the two lines
Apm = [lm1'; lm4'];
pm = null(Apm, 'r');  

% Compute the terms needed to plot the lines
xm1 = linspace(330, 680);  
ym1 = (-lm1(1)*xm1 - lm1(3)) / lm1(2);
xm4 = linspace(108, 1600);  
ym4 = (-lm4(1)*xm4 - lm4(3)) / lm4(2);

%% Find the line at the infinity 
Alinfty=[pl';pm'];
linfty = null(Alinfty, 'r');  
disp(linfty);
% Compute the terms needed to plot the lines
xlinfty = linspace(0, 3366.4);  
ylinfty = (-linfty(1)*xlinfty - linfty(3)) / linfty(2);

%% Image show
% Reading the image file
img = imread('scene.jpg');
img_gray = rgb2gray(img);

% Plotting the image
fig = figure();
imshow(img), hold on

% Plot the line at the infinity
plot(xlinfty, ylinfty, 'r-', 'LineWidth', 1.5);

% Plot the line and cvanishing point for the width
plot(xl1, yl1, 'r-', 'LineWidth', 1.5);
plot(xl4, yl4, 'r-', 'LineWidth', 1.5);
plot(pl(1), pl(2), append('black', '+'));

% Plot the line and cvanishing point for the depth
plot(xm1, ym1, 'r-', 'LineWidth', 1.5);
plot(xm4, ym4, 'r-', 'LineWidth', 1.5);
plot(pm(1), pm(2), append('black', '+'));

hold off