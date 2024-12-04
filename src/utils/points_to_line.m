function [l] = points_to_line(x1, y1, x2, y2)
    % Function used to compute the the line throug two points
    %
    % Inputs:
    %   x1 - scalar representing the x coordinate of the first point
    %   y2 - scalar representing the y coordinate of the first point
    %   x2 - scalar representing the x coordinate of the second point
    %   y2 - scalar representing the y coordinate of the second point
    %
    % Output:
    %   l - 1x3 vector [a, b, c] representing the line passing through 
    %       the given point

    % Represent the points in homogeneous coordinates by simply adding 
    % w = 1
    p1 = [x1; y1; 1];
    p2 = [x2; y2; 1];

    % Compute the line in homogeneous coordinates with cross product
    l = cross(p1, p2);
end