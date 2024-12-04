% ====================================================================
%                            Vanishing line
% ====================================================================

% Import utils 
addpath('iacv_homework\utils');


% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Width vanishing point
% Consider four points for the width
% They are found using corners_finder.m and imported manually (and
% modified)

% Find the two lines (parallel in the real object) identified by the two
% pair of points 
ll1 = points_to_line(109, 23, 1019, 153);
ll3 = points_to_line(126, 553, 879, 526);

% Find the intersection point of the two lines, that is the vanishing point
pl = lines_intersection(ll1, ll3);


%% Depth vanishing point
% Consider four points for the depth
% They are found using corners_finder.m and imported manually (and
% modified)

% Find the two lines (parallel in the real object) identified by the two
% pair of points 
lm1 = points_to_line(109, 23, 170, 229);
lm4 = points_to_line(1019, 153, 834, 278);

% Find the intersection point of the two lines, that is the vanishing point
pm = lines_intersection(lm1, lm4);


%% Height vanishing point (for later use) 
% Consider four points for the height
% They are found using corners_finder.m and imported manually (and
% modified)
lh1 = points_to_line(1131, 455, 1020, 153); % right
lh4 = points_to_line(108, 22, 37, 466); % left

% Find the intersection point of the two lines, that is the vanishing point
ph = lines_intersection(lh1, lh4);


%% Find the line at the infinity 
% We can find the parameters of the line at the infinity by simply finding 
% the line that pass through the vanishing points
l_infty = points_to_line(pl(1), pl(2), pm(1), pm(2));


%% Plotting the image with the lines previously found
% Plotting the image
fig = figure();
imshow(img), hold on

% Plotting the lines for the width dimension l
line_plotter(ll1, 0, 3400, 'r-')
line_plotter(ll3, 0, 3400, 'r-')

% Plotting the lines for the depth dimension m
line_plotter(lm1, 100, 330, 'r-')
line_plotter(lm4, 108, 1200, 'r-')

% Plot the lvanishing points for width and depth, respectively
point_plotter(pl, 'k.'); 
point_plotter(pm, 'k.');

% Plotting the line at the infinity
line_plotter(l_infty, 0, 3400, 'c-')

hold off


%% Save the line at the infinity in a file
% The file is called vanishing.mat
save('iacv_homework\variables\vanishing.mat', 'l_infty', 'pl', 'pm', 'ph');