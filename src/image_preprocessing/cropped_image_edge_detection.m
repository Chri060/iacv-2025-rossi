% =====================================================================
%                            Edges detection
% =====================================================================

% Import utils 
addpath('iacv_homework\utils');

% Clear all variables and close all
clear;
close all;

% Import the image
img = imread('iacv_homework\images\cropped.jpg');


%% Preprocessing the image to get a better result
grayImg = rgb2gray(img);
grayImg = imsharpen(grayImg, 'Radius', 10, 'Amount', 10);  % Adjust parameters
edges = edge(grayImg, 'Canny');  % Canny edge detection


%% Apply Harris corner detection to the modified image
points_harris = detectHarrisFeatures(grayImg, 'MinQuality', 0.001, 'FilterSize', 3); 


%% Show the image with edges and Harris points
imshow(img);
hold on;

% Plot Harris points on top of the image
scatter(points_harris.Location(:,1), points_harris.Location(:,2), 50, 'r', 'filled');

% Loop through each Harris point to label it
for i = 1:size(points_harris.Location, 1)
    text(points_harris.Location(i,1) + 5, points_harris.Location(i,2), ...
         num2str(i), 'Color', 'blue', 'FontSize', 8);
end

title('Canny Edge + Harris Corner Detection');


%% Show the image with only the manually selected points
points = [  points_harris.Location(155,1), points_harris.Location(155,2); 
            points_harris.Location(208,1), points_harris.Location(208,2); 
            points_harris.Location(1693,1), points_harris.Location(1693,2); 
            points_harris.Location(1707,1), points_harris.Location(1707,2); 
            points_harris.Location(2512,1), points_harris.Location(2512,2); 
            points_harris.Location(2548,1), points_harris.Location(2548,2); 
            points_harris.Location(3446,1), points_harris.Location(3446,2); 
            points_harris.Location(3469,1), points_harris.Location(3469,2); 
            points_harris.Location(396,1), points_harris.Location(396,2); 
            points_harris.Location(1603,1), points_harris.Location(1603,2); 
            points_harris.Location(2009,1), points_harris.Location(2009,2); 
            points_harris.Location(2983,1), points_harris.Location(2983,2); 
            points_harris.Location(17,1), points_harris.Location(17,2); 
            points_harris.Location(1,1), points_harris.Location(1,2); 
            points_harris.Location(1741,1), points_harris.Location(1741,2); 
            points_harris.Location(1788,1), points_harris.Location(1788,2); 
            points_harris.Location(2855,1), points_harris.Location(2855,2); 
            points_harris.Location(2912,1), points_harris.Location(2912,2); 
            points_harris.Location(3796,1), points_harris.Location(3796,2); 
            points_harris.Location(3832,1), points_harris.Location(3832,2); 
            points_harris.Location(268,1), points_harris.Location(268,2); 
            points_harris.Location(2553,1), points_harris.Location(2553,2); 
            points_harris.Location(2918,1), points_harris.Location(2918,2)
];

imshow(img);
hold on;

% Plot Harris points on top of the image
scatter(points(:,1), points(:,2), 50, 'r', 'filled');

% Loop through each Harris point to label it
for i = 1:size(points, 1)
    text(points(i,1) + 5, points(i,2), ...
         num2str(i), 'Color', 'blue', 'FontSize', 8);
end


%% Save the useful points in a variable
save('iacv_homework\variables\points.mat', 'points');