function [conic] = conic_extractor(conic_points)
    % CONIC_EXTRACTOR Extracts the conic matrix from a set of points lying on the conic.
    %
    % This function computes the conic matrix corresponding to a set of 
    % points that lie on a conic in the plane. The points are used to 
    % construct a system of equations in general form, which is solved using 
    % Singular Value Decomposition (SVD) to extract the conic parameters.
    %
    % Inputs:
    %   conic_points - Nx2 matrix of points [x, y] lying on the conic. 
    %                  These points should represent a geometric conic.
    %
    % Outputs:
    %   conic        - 3x3 symmetric matrix representing the conic in general 
    %                  quadratic form:
    %                  Ax^2 + By^2 + Cxy + Dx + Ey + F = 0.
    %
    % Example:
    %   points = [1, 2; 3, 4; 5, 6; 7, 8];
    %   conic = conic_extractor(points);
    %
    % Notes:
    %   - The function uses Singular Value Decomposition (SVD) to solve 
    %     the system and find the parameters of the conic.
    %   - The resulting matrix `conic` is symmetric and corresponds to 
    %     the conic in the form of a second-degree polynomial.
    
    % Extract the x and y coordinates from conic_points
    x = conic_points(:, 1); 
    y = conic_points(:, 2); 
    
    % Build the design matrix A for the system of equations representing the conic
    A = [x.^2, x.*y, y.^2, x, y, ones(size(x))];
    
    % Solve for the conic parameters by computing the Right Null Space of A
    [~, ~, V] = svd(A); 
    N = V(:, end);
    
    % The matrix N contains the parameters for the conic equation
    cc = N(:, 1);
    
    % Rename the parameters for clarity
    [a, b, c, d, e, f] = deal(cc(1), cc(2), cc(3), cc(4), cc(5), cc(6));
    
    % Define the conic matrix representing the general conic equation
    conic = [ a, b/2, d/2;  b/2, c, e/2;  d/2, e/2, f];
end