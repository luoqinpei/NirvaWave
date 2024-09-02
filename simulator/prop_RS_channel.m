function H = prop_RS_channel(M, L,freq, z)
    dx = L/M;

    c =  physconst('LightSpeed');
    wlen = c./freq;
    k = (2*pi)/wlen;
        
   % # Define frequency domain
    fx=((1/(dx))*((-M/2:M/2-1)/M)).';
    
    %# Convolution kernel in frequency domain
    H = exp(1i*k*z.*sqrt(1-(wlen.*fx).^2));
    H = fftshift(H);

    %# Convolve by multiplying in frequency domain

end