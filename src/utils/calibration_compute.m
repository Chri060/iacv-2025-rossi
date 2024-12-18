function [IAC, K] = calibration_compute(vanishingPoints, rectificationMatrix)
    % Inputs:
    %   vanishingPoints - a 3x3 matrix, each row contains the [x, y, 1] homogeneous coordinates of a vanishing point
    %   rectificationMatrix - a 3x3 rectification matrix for horizontal planes
    
    % Ensure vanishing points are in homogeneous coordinates
    if size(vanishingPoints, 2) == 2
        vanishingPoints = [vanishingPoints, ones(size(vanishingPoints, 1), 1)];
    end
    
    % Initialize matrix A
    A = [];
    
    % Construct matrix A using vanishing points
    for i = 1:3
        v = vanishingPoints(i, :); % Extract vanishing point
        A = [A;
             v(1)^2, 2*v(1)*v(2), 2*v(1), v(2)^2, 2*v(2), 1];
    end

    % Solve for the elements of w using SVD
    [~, ~, V] = svd(A);
    w = V(:, end); % The solution is the last column of V

    % Form the Image of the Absolute Conic (IAC) matrix
    W = [w(1), w(2), w(3);
         w(2), w(4), w(5);
         w(3), w(5), w(6)];

    % Transform the IAC using the rectification matrix
    H_inv = inv(rectificationMatrix);
    IAC = H_inv' * W * H_inv;

    % Extract intrinsic parameters from the IAC
    alfa = sqrt(IAC(1, 1));
    u0 = -IAC(1, 3) / alfa^2;
    v0 = -IAC(2, 3);
    fy = sqrt(IAC(3, 3) - (alfa^2) * u0^2 - v0^2);
    fx = fy / alfa;

    % Build the intrinsic parameters matrix K
    K = [fx, 0, u0;
         0, fy, v0;
         0,  0, 1];

    % Normalize K so that K(3,3) = 1
    K = K / K(3, 3);
end

