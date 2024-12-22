function [intersection] = lines_intersection(l1, l2)
    % LINES_INTERSECTION Computes the intersection point of two lines in 2D space.
    %
    % This function calculates the intersection point of two lines given in 
    % homogeneous coordinates (ax + by + c = 0). If the lines are parallel or 
    % coincident, the function returns an empty array.
    %
    % Inputs:
    %   l1 - 1x3 vector [a1, b1, c1] representing the first line in homogeneous coordinates.
    %   l2 - 1x3 vector [a2, b2, c2] representing the second line in homogeneous coordinates.
    %
    % Output:
    %   intersection - 1x2 vector [x, y] representing the intersection point in Cartesian coordinates,
    %                  or [] if the lines are parallel or coincident.
    %
    % Example:
    %   l1 = [1, -1, -1]; % Line: x - y - 1 = 0
    %   l2 = [1, 1, -3];  % Line: x + y - 3 = 0
    %   intersection = lines_intersection(l1, l2);
    %   % Returns: intersection = [2, 1]
    %
    % Note:
    %   The input lines are assumed to be normalized. If they are not, the function
    %   ensures normalization to avoid numerical instability.

    % Normalize the lines to ensure homogeneous coordinates are consistent
    l1 = l1 ./ l1(3);
    l2 = l2 ./ l2(3);
    
    % Compute the intersection in homogeneous coordinates using the cross product
    intersection = cross(l1, l2);

    % Check if the lines are parallel or coincident (intersection is at infinity)
    if abs(intersection(3)) < 1e-10
        % Lines are parallel or coincident, return an empty array
        intersection = []; 
    else
        % Convert the intersection coordinates
        intersection = intersection ./ intersection(3);
    end
end