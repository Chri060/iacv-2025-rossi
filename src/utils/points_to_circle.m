function [xc, yc, radius] = points_to_circle(points)
    % Input: points - Nx2 array of [x, y] coordinates
    % Output: circleParams with Center (1x2) and Radius (scalar)

    % Formulate the design matrix
    x = points(:,1);
    y = points(:,2);
    A = [2*x, 2*y, ones(size(x))];
    b = x.^2 + y.^2;

    % Solve the normal equations A*x = b
    sol = A\b;

    % Extract parameters
    xc = sol(1);
    yc = sol(2);
    radius = sqrt(sol(3) + xc^2 + yc^2);
end