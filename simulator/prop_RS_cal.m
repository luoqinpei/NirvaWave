function u2 = prop_RS_cal(u1, H)
%     """Compute diffracted field with the Rayleigh-Sommerfeld propagation using
%     the transfer function.
% 
    % 
    U1 = fft(u1);
    U2 = H.*U1;
    u2 = ifft(U2,length(U1));
    %# Convolve by multiplying in frequency domain
    % N = length(u1);
    % u1_padded = [zeros(N/2, 1);u1; zeros(N/2, 1)];
    % % H_padded = [H; zeros(N, 1)];
    % U1 = fft(u1_padded);
    % U2 = H .* U1;
    % u2_padded = ifft(U2);
    % u2 = [u2_padded(N/2:N-1);u2_padded(N+1:3*N/2)];
    
end