%%
% #########################################################################
% ----------------------- F1 - CORNERS DETECTION --------------------------
% #########################################################################

% reading the image file
img = imread('rectified.png');
img_gray = rgb2gray(img);

% find corners
[loc_x, loc_y] = findCorners(img_gray, 3, 200);

fig = figure();
imshow(img), hold on

% '+' marker for each corner detected at position (loc_y, loc_x)
plot(loc_y, loc_x, append('red', '+'));
title('Points detected');
hold off
