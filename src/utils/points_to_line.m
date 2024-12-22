function [l] = points_to_line(p1, p2)
    % POINTS_TO_LINE Computes the line passing through two points in homogeneous coordinates.
    %
    % This function takes two points represented in homogeneous coordinates and
    % calculates the line that passes through both points. The resulting line is
    % represented in homogeneous coordinates as a 1x3 vector [a, b, c], corresponding
    % to the equation ax + by + c = 0.
    %
    % Inputs:
    %   p1 - 1x3 vector representing a point in homogeneous coordinates.
    %   p2 - 1x3 vector representing a point in homogeneous coordinates.
    %
    % Output:
    %   l  - 1x3 vector representing the line in homogeneous coordinates.
    %
    % Example:
    %   p1 = [1, 2, 1];
    %   p2 = [3, 4, 1];
    %   l = points_to_line(p1, p2);
    %   % Returns a line l such that l * [x; y; 1] = 0 passes through p1 and p2.

    % Normalize the points to ensure they are in standard form
    p1 = p1 ./ p1(3);
    p2 = p2 ./ p2(3);

    % Compute the line in homogeneous coordinates using the cross product
    l = cross(p1, p2);
end