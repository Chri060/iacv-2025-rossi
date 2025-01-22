function [ellipse, code] = matrix_to_geometric(parameters)
    % MATRIX_TO_ANALYTICAL - Convert conic algebraic parameters to geometric parameters.
    %  
    % This function converts the algebraic representation of a conic section
    % (ellipse, hyperbola, or parabola) into its geometric properties, such as
    % center, semi-axes, and rotation angle. It also classifies the type of conic.
    % 
    % Inputs:
    %   parameters - [6x1 double] Parameter vector of the conic:
    %                parameters = [A, B, C, D, E, F]', where:
    %                A, B, C are coefficients of quadratic terms (Ax^2 + Bxy + Cy^2),
    %                D, E are coefficients of linear terms (Dx + Ey),
    %                F is the constant term.
    %
    % Outputs:
    %   ellipse - Structure containing geometric parameters of the conic:
    %             .Center - [1x2 double] Coordinates of the center.
    %             .SemiAxes - [1x2 double] Semi-major and semi-minor axes lengths.
    %             .RotationAngle - [double] Rotation angle (in radians).
    %           -1 - degenerate cases  
    %            0 - imaginary ellipse  
    %            4 - imaginary parelle lines
    %
    %   code - [int] Conic type identifier:
    %          1 - Ellipse
    %          2 - Hyperbola
    %          3 - Parabola
    %         -1 - Degenerate cases
    %          0 - Imaginary ellipse
    %          4 - Imaginary parallel lines
    %
    % Example:
    %   paramteres = [1; 0; 1; 0; 0; -1]; % Unit circle: x^2 + y^2 - 1 = 0
    %   [ellipse, code] = matrixToAnalytical(paramteres);
    % Note:
    %   - Degenerate cases are detected when the determinant of the conic matrix is zero.
    %   - Imaginary conics are identified based on specific conditions of the determinant.

    % Tolerance values for numerical stability
    tolerance1 = 1.e-10;
    tolerance2 = 1.e-20;
    
    % Calculate the rotation angle of the conic
    if (abs(parameters(1) - parameters(3)) > tolerance1)
        Angle = atan(parameters(2) / (parameters(1) - parameters(3))) / 2;
    else
        Angle = pi/4;
    end

    % Construct rotation matrix
    c = cos(Angle);  
    s = sin(Angle);
    Q = [c, s;  -s, c];

    % Define the quadratic and linear coefficient matrices
    M = [parameters(1), parameters(2) / 2;  parameters(2) / 2,  parameters(3)];
    D = Q * M * Q';
    N = Q * [parameters(4);  parameters(5)];
    O = parameters(6);
    
    % Normalize coefficients for positive definite matrix D
    if (D(1, 1) < 0) && (D(2, 2) < 0)
        D = -D;
        N = -N;
        O = -O;
    end
    
    % Calculate the center of the conic in UV-coordinates
    UVcenter = [-N(1, 1) / 2 / D(1, 1);  -N(2, 1) / 2 / D(2, 2)];
    free = O - UVcenter(1, 1) * UVcenter(1, 1) * D(1, 1) - UVcenter(2, 1) * UVcenter(2, 1) * D(2, 2);
    
    % Detect degenerate cases using determinant analysis
    Deg =[parameters(1), parameters(2) / 2 ,parameters(4) / 2;...
         parameters(2) / 2, parameters(3), parameters(5) / 2;...
         parameters(4) / 2, parameters(5) / 2, parameters(6)];
    K1 = [parameters(1), parameters(4) / 2;  parameters(4) / 2, parameters(6)];
    K2 = [parameters(3), parameters(5) / 2;  parameters(5) / 2, parameters(6)];
    K = det(K1) + det(K2);
    
    if (abs(det(Deg)) < tolerance2)
        if (abs(det(M))<tolerance2) &&(K > tolerance2)
            code = 4;  % Imaginary parallel lines
        else
            code = -1; % Degenerate cases
        end
    else
        if (D(1,1)*D(2,2) > tolerance1)
            if (free < 0)
                code = 1; % Ellipse
            else
                code = 0; % Imaginary ellipse
            end
        elseif (D(1,1)*D(2,2) < - tolerance1)
            code = 2;  % Hyperbola
        else
            code = 3;  % Parabola
        end
    end
    
    % Convert center to XY-coordinates
    XYcenter = Q' * UVcenter;

    % Calculate semi-axes lengths
    Axes = [sqrt(abs(free / D(1,1)));  sqrt(abs(free / D(2, 2)))];
    
    % Adjust parameters for specific conic cases
    if code == 1 && Axes(1) < Axes(2)
        Axes = flip(Axes);
        Angle = Angle + pi / 2;
    end

    if code == 2 && free * D(1, 1) > 0
        Axes = flip(Axes);
        Angle = Angle + pi / 2;
    end

    % Normalize angle to range [0, pi]
    Angle = mod(Angle, pi);

    % Package output into structure
    ellipse.Center = XYcenter';
    ellipse.SemiAxes = Axes';
    ellipse.RotationAngle = Angle;
end