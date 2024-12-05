% =====================================================================
%                            Edges detection
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\height.jpg');


%% Preprocessing the image to get a better result
grayImg = rgb2gray(img);
grayImg = imsharpen(grayImg, 'Radius', 4, 'Amount', 10);  % Adjust parameters


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
points = [  points_harris.Location(144,1), points_harris.Location(144,2); 
            points_harris.Location(224,1), points_harris.Location(224,2); 
            points_harris.Location(6244,1), points_harris.Location(6244,2); % 3512
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
save('iacv_homework\variables\height_points.mat', 'points');