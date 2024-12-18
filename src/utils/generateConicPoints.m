function points = generateConicPoints(img, S, numPoints)
    % Generates distinct points on a conic within image bounds
    %
    % Inputs:
    %   img - Input image (used to determine bounds)
    %   S - 3x3 conic matrix
    %   numPoints - Number of points to generate
    %
    % Output:
    %   points - 2xN matrix of [x; y] coordinates on the conic within image bounds

    % Get image dimensions
    [imgHeight, imgWidth, ~] = size(img);

    % Initialize points array
    points = zeros(2, numPoints); % Each column is a point [x; y]
    count = 0;

    % Generate points iteratively
    while count < numPoints
        % Randomly sample (x, y) within image bounds
        x = randi([1, imgWidth]); % Random x-coordinate in image bounds
        y = randi([1, imgHeight]); % Random y-coordinate in image bounds

        % Form homogeneous coordinate
        x_h = [x; y; 1];

        % Check if the point satisfies the conic equation
        if abs(x_h' * S * x_h) < 1e-6 % Point lies on the conic
            % Check if the point is unique
            isUnique = all(~ismember(points(:, 1:count)', [x, y], 'rows'));
            if isUnique
                count = count + 1;
                points(:, count) = [x; y];
            end
        end
    end
end
