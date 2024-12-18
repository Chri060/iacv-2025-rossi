function theta = angle_between_lines(l1, l2)
    % Function to compute the angle between two lines in degrees.
    %
    % Inputs:
    %   l1 - 1x3 vector [a, b, c] representing the first line
    %   l2 - 1x3 vector [a, b, c] representing the second line
    %
    % Output:
    %   theta - scalar containing the angle between the two given lines in degrees

    % Normalize the line coefficients (optional for better numerical stability)
    l1 = l1 / norm(l1(1:2));
    l2 = l2 / norm(l2(1:2));

    % Compute the dot product of the two normal vectors (a, b)
    dot_product = l1(1) * l2(1) + l1(2) * l2(2);

    % Calculate the angle in radians using arccos
    theta_rad = acos(abs(dot_product)); % Use abs to ensure the angle is non-negative

    % Convert the angle to degrees
    theta = rad2deg(theta_rad);
end