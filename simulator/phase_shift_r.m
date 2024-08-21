function phase_shift = phase_shift_r(hrms,Lc,RL,N,lambda)
    x = linspace(-RL/2,RL/2,N);
    Z = hrms.*randn(N,1);
    F = exp(-((x.^2)/(Lc^2/2)))';
    f = 2/sqrt(pi)*RL/(N)*ifft(fft(Z).*fft(F));
    phase_shift = 2*pi.*f/lambda/1000;
end