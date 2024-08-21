function H = prop_RS_channel_g(M, L,freq, z,theta)
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
    dx = L/M;

    c =  physconst('LightSpeed');
    wlen = c./freq;
    k = (2*pi)/wlen;
   % # Define frequency domain
    %fx = -1/(2*dx):1.0/L:1/(2*dx); 
    fx=((1/(dx))*((-M/2:M/2-1)/M)).';
    %shift = z.*tan(theta)/M;
    %fx_m = -M/2:M/2-1;
    %fx_m = fx_m/(M*wlen/2);
    %scalex = fx./fx_m;
    %scale = scalex(1);
    %theta_x = (asin(fx_m*wlen)+theta)';
    %# Convolution kernel in frequency domain
    %k_x = k * sin(theta);
    %k_z = k * cos(theta);
    H = exp(1i*k*z./cos(theta).*sqrt(1-(wlen.*cos(theta).*fx).^2));
    %H = exp(1i*(fx*sin(theta)+k*cos(theta))*z.*sqrt(1-(wlen.*(fx.*cos(theta)-k*sin(theta))).^2));
    % Convolution kernel in frequency domain
    %H = exp(1i * k_z.*fx * z) .* exp(1i * k_x .* fx * z);
    H = fftshift(H);

    %# Convolve by multiplying in frequency domain

end