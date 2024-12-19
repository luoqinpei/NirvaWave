function H = prop_RS_channel_g(M, L,freq, z,theta)
%     """Compute diffracted field with the Rayleigh-Sommerfeld propagation using
%     the transfer function.
    dx = L/(M-1);
    c =  physconst('LightSpeed');
    wlen = c./freq;
    k = (2*pi)/wlen;
    %fx=((1/(dx))*((-M/2:M/2-1)/M)).';
    fx=((1/(dx))*((-(M-1)/2:(M-1)/2)/(M-1))).';
    H = exp(1i*k*z./cos(theta).*sqrt(1-(wlen.*cos(theta).*fx).^2));
    H = ifftshift(H);
end