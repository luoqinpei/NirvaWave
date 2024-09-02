function B_transformed = transforam_cord(Z,Y,B,theta,tx,ty,mirror)
    [Z_grid, Y_grid] = meshgrid(Z, Y);
    Z_flat = Z_grid(:)-tx;
    Y_flat = Y_grid(:)-ty;
    if mirror==true
        B = interp2(Z_grid, Y_grid, B, Z_grid, -Y_grid, 'linear', 0);
    end
    
    
    % Apply the rotation
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    coords_rotated = R * [Z_flat'; Y_flat'];
    % Apply the translation
    Z_transformed = coords_rotated(1, :);
    Y_transformed = coords_rotated(2, :);
    % Interpolate the matrix B onto the transformed grid
    Z_transformed_grid = reshape(Z_transformed, size(Z_grid));
    Y_transformed_grid = reshape(Y_transformed, size(Y_grid));
    
    B_transformed = interp2(Z_grid, Y_grid, B, Z_transformed_grid, Y_transformed_grid, 'linear', 0);
end