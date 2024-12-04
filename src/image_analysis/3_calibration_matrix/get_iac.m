function IAC = get_iac(l_infty, ph, pl, pm, H)
    % This function computes the Image of the Absolute Conic (IAC)
    %
    % Inputs:
    %   - l_infty: 1x3 vector representing the line at the infinity
    %   - ph: 1x3 vector representing the vanishing point of the vertical
    %   - pm: 1x3 vector representing the first vanishing point of the horizontal plane 
    %   - pl: 1x3 vector representing the second vanishing point of the horizontal plane 
    %   - H: 3x3 matrix representing the homography matrix
    %
    % Output:
    %   - IAC: 3x3 matrix representing the image of the absolute conic
    

    %% Parametric IAC matrix definition
    % Parametrization of the IAC matrix called omega
    syms a b c d;
    omega = [a, 0, b; 
             0, 1, c; 
             b, c, d];
    
    % Initialize constraint matrices
    X = []; % Design matrix for linear system
    Y = []; % Target vector
    

    %% Add constraints from lines at infinity and vanishing points
    % Constraint: l_inf' * omega * vp = 0
    eqn = []; % Initialize equation container
     
    % Compute the cross-product matrix for the line
    lx = [0             -l_infty(3)     l_infty(2); 
          l_infty(3)    0               -l_infty(1); 
          -l_infty(2)   l_infty(1)      0];
    
    % Extract the corresponding vanishing point
    xi = ph(:, 1);
    
    % Add the two constraints for this line-vanishing point pair
    eqn = [eqn, lx(1, :) * omega * xi == 0, ...
                 lx(2, :) * omega * xi == 0];
 
    % Convert symbolic equations into matrix form
    [A, y] = equationsToMatrix(eqn, [a, b, c, d]);
    X = [X; double(A)]; % Append constraints to design matrix
    Y = [Y; double(y)]; % Append targets
    

    %% Add orthogonality constraints for vanishing points
    % Constraint: vp1' * omega * vp2 = 0
    eqn = []; % Reset equation container

    % Add the orthogonality constraint
    eqn = [eqn, pl(:, 1).' * omega * pm(:, 1) == 0];

    if ~isempty(eqn)
        % Convert symbolic equations into matrix form
        [A, y] = equationsToMatrix(eqn, [a, b, c, d]);
        X = [X; double(A)]; % Append constraints to design matrix
        Y = [Y; double(y)]; % Append targets
    end
    

    %% Add constraints from the homography (circular points)
    if ~isempty(H)
        % Extract homography columns
        h1 = H(:,1);
        h2 = H(:,2);
    
        % Add circular point constraints:
        % 1. h1' * omega * h2 = 0
        % 2. h1' * omega * h1 = h2' * omega * h2
        eq1 = h1.' * omega * h2 == 0;
        eq2 = h1.' * omega * h1 == h2.' * omega * h2;
        
        % Convert symbolic equations into matrix form
        [A, y] = equationsToMatrix([eq1, eq2], [a, b, c, d]);
        X = [X; double(A)]; % Append constraints to design matrix
        Y = [Y; double(y)]; % Append targets
    end
    

    %% Solve for the IAC parameters using a linear model
    % Fit a linear model without intercept to solve for [a, b, c, d]
    coeffs = X \ Y; % Least-squares solution
    
    % Construct the IAC matrix
    IAC = [coeffs(1),   0,          coeffs(2); 
           0,           1,          coeffs(3); 
           coeffs(2),   coeffs(3),  coeffs(4)];
    IAC = double(IAC); % Ensure numeric output
end