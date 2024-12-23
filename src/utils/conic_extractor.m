function [C] = conic_extractor(C_points)
    % Extract the x and y coordinates from C_points
    x = C_points(:, 1); 
    y = C_points(:, 2); 
    
    % Build the design matrix A that represents the system of equations
    % for the conic in the general form Ax^2 + By^2 + Cxy + Dx + Ey + F = 0
    A = [x.^2, x.*y, y.^2, x, y, ones(size(x))];
    
    % To solve for the conic parameters, we need the Right Null Space of A
    % which represents the coefficients of the conic.
    [~, ~, V] = svd(A); 
    N = V(:, end);
    
    % The matrix N contains the parameters for the conic equation
    cc = N(:, 1);
    
    % Rename the parameters for clarity
    [a, b, c, d, e, f] = deal(cc(1), cc(2), cc(3), cc(4), cc(5), cc(6));
    
    % Define the conic matrix for the general conic equation
    C = [ a, b/2, d/2;  b/2, c, e/2;  d/2, e/2, f];
end