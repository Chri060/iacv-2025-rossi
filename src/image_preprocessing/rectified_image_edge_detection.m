% =====================================================================
%                            Edges detection
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\rectified.jpg');


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
points = [  points_harris.Location(388,1), points_harris.Location(388,2); 
            points_harris.Location(16,1), points_harris.Location(16,2); 
           points_harris.Location(2360,1), points_harris.Location(2360,2); % 3512

            points_harris.Location(78,1), points_harris.Location(78,2); 
            points_harris.Location(228,1), points_harris.Location(228,2); 
            points_harris.Location(25,1), points_harris.Location(25,2); 
            points_harris.Location(312,1), points_harris.Location(312,2); 
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
save('iacv_homework\variables\rect_points.mat', 'points');