function A_transformed = inverse_transform_matrix(A, theta, T)
    % Get dimensions of the matrices
    [N, M] = size(A);
    
    % Initialize the transformed matrix with NaN
    A_transformed = NaN(size(A));
    
    % Create a grid of coordinates for matrix B
    [x, y] = meshgrid(1:M, 1:N);
    
    % Flatten the grid coordinates
    coords = [x(:), y(:), ones(numel(x), 1)]';
    
    % Define the transformation matrix
    T_x = T(1);
    T_y = T(2);
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    
    % Affine transformation matrix combining rotation and translation
    A_matrix = [R, [T_x; T_y]; 0, 0, 1];
    
    % Compute the inverse transformation matrix
    A_matrix_inv = inv(A_matrix);
    
    % Apply the inverse transformation
    transformed_coords = A_matrix * coords;
    
    % Normalize homogeneous coordinates
    transformed_coords = transformed_coords(1:2, :) ./ transformed_coords(3, :);
    
    % Round the transformed coordinates to the nearest integers
    x_transformed = round(transformed_coords(1, :));
    y_transformed = round(transformed_coords(2, :));
    
    % Map the transformed coordinates to the original matrix
    for i = 1:numel(x_transformed)
        x_new = x_transformed(i);
        y_new = y_transformed(i);
        if x_new >= 1 && x_new <= M && y_new >= 1 && y_new <= N
            A_transformed(y(i), x(i)) = A(y_new, x_new);
        end
    end
end