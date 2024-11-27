%% Image importing
% Reading the image file
img = imread('rectified.png');
img_gray = rgb2gray(img);

%% Hough Transformation to find the lines
% Canny Algorithm for edge detection
edges = edge(img_gray, 'Canny', [0.0125 0.0312]);

% Hough Transformation space
[H, theta, rho] = hough(edges);

% Hough peaks for line detection
peaks = houghpeaks(H, 50, 'threshold', ceil(0.3*max(H(:))), 'NHoodSize', [97 37]);

% Line formatting through Hough Transformation
lines = houghlines(edges, theta, rho, peaks, 'FillGap', 1000, 'MinLength', 500);

%% Image displaying with the lines
% Create a figure for displaying the image
fig = figure();
imshow(img), hold on


lines_final(1) = lines(1);
lines_final(2) = lines(7);
lines_final(3) = lines(16);
lines_final(4) = lines(27);

% For each line detected, plot and label it
for k = 1:length(lines_final)
    xy = [lines_final(k).point1; lines_final(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 1, 'Color', 'red');
    text(lines_final(k).point1(1), lines_final(k).point1(2), int2str(k), 'FontSize', 15, 'Color', 'white'); 
end
title('Lines Detected');