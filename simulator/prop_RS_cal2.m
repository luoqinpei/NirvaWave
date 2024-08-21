function u2 = prop_RS_cal2(u1, H,M)
%     """Compute diffracted field with the Rayleigh-Sommerfeld propagation using
%     the transfer function.
% 
    % 
    U1 = fft(u1);
    U2 = H.*U1.*M;
    u2 = ifft(U2,length(U1));
    %# Convolve by multiplying in frequency domain
    % N = length(u1);
    % u1_padded = [zeros(N/2, 1);u1; zeros(N/2, 1)];
    % H_padded = [H; zeros(N, 1)];
    % U1 = fft(u1_padded);
    % U2 = H_padded .* U1;
    % u2_padded = ifft(U2);
    % u2 = u2_padded(1:N);
    
end