function [theta] = angle_between_lines(l1, l2)
    % ANGLE_BETWEEN_LINES Computes the angle between two lines in degrees.
    %
    % This function calculates the angle between two lines defined by their 
    % coefficients in the form ax + by + c = 0. The angle is computed as 
    % the angle between the normal vectors to the lines.
    %
    % Inputs:
    %   l1 - 1x3 vector [a1, b1, c1] representing the first line equation (ax + by + c = 0)
    %   l2 - 1x3 vector [a2, b2, c2] representing the second line equation (ax + by + c = 0)
    %
    % Output:
    %   theta - Scalar angle (in degrees) between the two lines.
    %
    % Example:
    %   l1 = [1, -1, 0]; % Line equation x - y = 0
    %   l2 = [1, 1, 0];  % Line equation x + y = 0
    %   theta = angle_between_lines(l1, l2); % Returns the angle between the lines

    % Normalize the line vectors (consider only the first two components, a and b)
    % This is done for better numerical stability and to ensure consistency in magnitude.
    l1 = l1 / norm(l1(1:2));
    l2 = l2 / norm(l2(1:2));

    % Compute the dot product of the two normal vectors
    dot_product = l1(1) * l2(1) + l1(2) * l2(2);

    % Calculate the angle in radians using arccos
    theta_rad = acos(abs(dot_product));

    % Convert the angle from radians to degrees
    theta = rad2deg(theta_rad);
end