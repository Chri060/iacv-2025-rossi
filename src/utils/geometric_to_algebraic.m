function output_parameters = geometric_to_algebraic(parameters)
    % GEOMETRIC_TO_ALGEBRAIC Converts geometric ellipse parameters to algebraic form.
    %
    % This function converts the geometric representation of an ellipse into
    % its algebraic parameter vector used in conic equations.
    %
    % Inputs:
    %   parameters - [1x5 double] Geometric parameters of the ellipse:
    %                [CenterX, CenterY, SemiAxisX, SemiAxisY, RotationAngle(degrees)]
    %                where:
    %                  CenterX, CenterY - Coordinates of the ellipse center.
    %                  SemiAxisX, SemiAxisY - Lengths of the semi-major and semi-minor axes.
    %                  RotationAngle - Angle of rotation of the ellipse (in degrees).
    %
    % Outputs:
    %   output_parameters - [6x1 double] Algebraic parameter vector of the conic:
    %                       [A, B, C, D, E, F]', where:
    %                         A, B, C - Quadratic coefficients (Ax^2 + Bxy + Cy^2)
    %                         D, E - Linear coefficients (Dx + Ey)
    %                         F - Constant term.
    %
    % Example:
    %   parameters = [2, 3, 5, 2, 30];
    %   output_parameters = geometric_to_algebraic(parameters);
    %
    % Note:
    %   - The function assumes the input parameters define a valid ellipse.
    %   - The rotation angle should be specified in degrees.
    
    % Extract input parameters
    c = cosd(parameters(5));  
    s = sind(parameters(5));
    a = parameters(3);  
    b = parameters(4);
    Xc = parameters(1);  
    Yc = parameters(2);
    
    % Compute quadratic coefficients
    P = (c / a)^2 + (s / b)^2;
    Q = (s / a)^2 + (c / b)^2;
    R = 2 * c * s * (1 / a^2 - 1 / b^2);

    % Compute linear and constant coefficients
    output_parameters = [P; R; Q; -2 * P * Xc - R * Yc; -2 * Q * Yc - R * Xc; P * Xc^2 + Q * Yc^2 + R * Xc * Yc - 1];
end