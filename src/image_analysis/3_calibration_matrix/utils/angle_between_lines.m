function theta = angle_between_lines(l1, l2)
    % Function used to compute the angle between two lines
    %
    % Inputs:
    %   l1 - 1x3 vector [a, b, c] representing the first line
    %   l2 - 1x3 vector [a, b, c] representing the second line
    %   max - scalar for right border for the x coordinate 
    %
    % Output:
    %   theta - scalar containing the angle between the two given lines

    % Computes the slope of the two lines
    m1 = -l1(1) / l1(2);
    m2 = -l2(1) / l2(2);
    
    % Calculate the angle in radians
    theta_rad = atan(abs((m1 - m2) / (1 + m1 * m2)));
    
    % Convert angle to degrees
    theta = rad2deg(theta_rad);
end