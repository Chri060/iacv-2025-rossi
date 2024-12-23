function points = generate_conic_points(img, S, numPoints, seed)
    % GENERATE_CONIC_POINTS Generates distinct points on a conic within image bounds.
    %
    % This function randomly generates points on a conic defined by the matrix S
    % and ensures the points lie within the bounds of the given image.
    %
    % Inputs:
    %   img       - Input image (used to determine bounds).
    %   S         - 3x3 symmetric matrix representing the conic equation x' * S * x = 0.
    %   numPoints - Number of points to generate on the conic.
    %   seed      - Seed for random number generation to ensure reproducibility.
    %
    % Output:
    %   points    - 2xN matrix of [x; y] coordinates on the conic within image bounds.
    %
    % Example:
    %   img = imread('example.jpg');
    %   S = [1, 0, -50; 0, 1, -50; -50, -50, 1];
    %   points = generate_conic_points(img, S, 10, 42);
    %   % Generates 10 points on the conic defined by S within the image bounds.
    %
    % Notes:
    %   - This function uses a threshold (1e-6) to approximate points lying on the conic.
    %   - Points are guaranteed to be unique.

    % Get image dimensions
    [imgHeight, imgWidth, ~] = size(img);

    % Initialize points array
    points = zeros(2, numPoints);
    count = 0;
    
    % Set the random seed for reproducibility
    rng(seed);

    % Generate points iteratively
    while count < numPoints
        % Randomly sample (x, y) within image bounds
        x = randi([1, imgWidth]); % Random x-coordinate
        y = randi([1, imgHeight]); % Random y-coordinate

         % Form the homogeneous coordinate
        x_h = [x; y; 1];

        % Check if the point satisfies the conic equation
        if abs(x_h' * S * x_h) < 1e-6
            % Check if the point is unique
            if ~ismember([x; y]', points(:, 1:count)', 'rows')
                % Add the point to the list
                count = count + 1;
                points(:, count) = [x; y];
            end
        end
    end
end
