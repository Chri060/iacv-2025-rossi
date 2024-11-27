% Input image
img = imread('scene.jpg');

%% Affine Euclidean rectification
% Define the line at infinity (a*x + b*y + c = 0)
linfty = [-0.000; -0.0011; 1.0000]; % Coefficients already normalized

linfty = linfty ./ (linfty(3));

% Create a homography to rectify the image
H = [eye(2), zeros(2,1); linfty(:)'];

fprintf('The vanishing line is mapped to꞉\n');
disp(inv(H)'*linfty);
% Here, H is a transformation matrix that makes the line at infinity (a, b, c)
% map to (0, 0, 1), i.e., the true line at infinity.

% Rectify the image using the homography
tform = projective2d(H');

[xLimits, yLimits] = outputLimits(tform, [1 size(img, 2)], [1 size(img, 1)]);
outputRef = imref2d([ceil(yLimits(2) - yLimits(1)) ceil(xLimits(2) - xLimits(1))]);
rectified_image = imwarp(img, tform, 'OutputView', outputRef);

% Display the rectified image
figure;
imshow(rectified_image);
title('Euclidean Rectified Image');
imwrite(rectified_image, 'rectified.png')