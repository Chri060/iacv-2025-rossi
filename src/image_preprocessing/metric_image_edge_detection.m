% =====================================================================
%                            Edges detection
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\metric.jpg');


%% Preprocessing the image to get a better result
grayImg = rgb2gray(img);
grayImg = imsharpen(grayImg, 'Radius', 1.5, 'Amount', 25);  % Adjust parameters


%% Apply Harris corner detection to the modified image
points_harris = detectHarrisFeatures(grayImg, 'MinQuality', 0.001, 'FilterSize', 3); 


%% Show the image with edges and Harris points
figure; 
imshow(img), hold on

% Plot Harris points on top of the image
scatter(points_harris.Location(:,1), points_harris.Location(:,2), 50, 'r', 'filled');

% Loop through each Harris point to label it
for i = 1:size(points_harris.Location, 1)
    text(points_harris.Location(i,1) + 5, points_harris.Location(i,2), ...
         num2str(i), 'Color', 'blue', 'FontSize', 8);
end

title('Canny Edge + Harris Corner Detection');


%% Show the image with only the manually selected points
points = [  points_harris.Location(534,1), points_harris.Location(534,2); 
            points_harris.Location(196,1), points_harris.Location(196,2); 
            points_harris.Location(7407,1), points_harris.Location(7407,2); 
];
figure; 
imshow(grayImg)
imshow(img), hold on;

% Plot Harris points on top of the image
scatter(points(:,1), points(:,2), 50, 'r', 'filled');

% Loop through each Harris point to label it
for i = 1:size(points, 1)
    text(points(i,1) + 5, points(i,2), ...
         num2str(i), 'Color', 'blue', 'FontSize', 8);
end


%% Save the useful points in a variable
save('iacv_homework\variables\metric_points.mat', 'points');