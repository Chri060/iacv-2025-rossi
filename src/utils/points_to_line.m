function [l] = points_to_line(p1, p2)
    % Function used to compute the the line throug two points
    %
    % Inputs:
    %   p1 - 1x3 vector representing a point in homogeneous coordinates
    %   p2 - 1x3 vector representing a point in homogeneous coordinates
    %
    % Output:
    %   l - 1x3 vector [a, b, c] representing the line passing through 
    %       the given points

    % Normalize the points
    p1 = p1 ./ p1(3);
    p2 = p2 ./ p2(3);

    % Compute the line in homogeneous coordinates with cross product
    l = cross(p1, p2);
end