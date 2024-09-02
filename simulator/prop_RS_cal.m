function u2 = prop_RS_cal(u1, H)
%     """Compute diffracted field with the Rayleigh-Sommerfeld propagation using
%     the transfer function.
% 
    U1 = fft(u1);
    U2 = H.*U1;
    u2 = ifft(U2,length(U1));
    
end