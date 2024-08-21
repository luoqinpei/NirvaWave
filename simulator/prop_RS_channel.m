function H = prop_RS_channel(M, L,freq, z)
%     """Compute diffracted field with the Rayleigh-Sommerfeld propagation using
%     the transfer function.
% 
%     Parameters
%     ----------
%     u1: 
%         2D field in source plane
%     L : float
%         Length and Width of system
%     wlen : 
%         wavelength
%     z : 
%         distance over which field is propagated

%     Returns
%     -------
%     numpy.array
%         The propagated complex field at location z (relative to source plane)
%     ""
    %M = 2*M;
    %L = 2*L;
    dx = L/M;

    c =  physconst('LightSpeed');
    wlen = c./freq;
    k = (2*pi)/wlen;
        
   % # Define frequency domain
    %fx = -1/(2*dx):1.0/L:1/(2*dx); 
    fx=((1/(dx))*((-M/2:M/2-1)/M)).';
    
    %# Convolution kernel in frequency domain
    H = exp(1i*k*z.*sqrt(1-(wlen.*fx).^2));
    H = fftshift(H);

    %# Convolve by multiplying in frequency domain

end