function [intersection] = lines_intersection(l1, l2)
    % Function used to compute the intersection point of two lines
    % in the form ax + by + c = 0
    %
    % Inputs:
    %   l1 - 1x3 vector [a1, b1, c1] representing the first line
    %   l2 - 1x3 vector [a2, b2, c2] representing the second line
    %
    % Output:
    %   intersection - 1x2 vector [x, y] representing the intersection point
    %                  or [] if the lines are parallel or coincident

    % Normalize the lines with respect to the parameter w
    l1 = l1 ./ l1(3);
    l2 = l2 ./ l2(3);
    
    % Compute the cross product of the two lines
    intersection = cross(l1, l2);

    % Check if the intersection is valid
    if intersection(3) == 0
        intersection = []; 
    else
        % Normalize the result
        intersection = intersection ./ intersection(3);
    end
end