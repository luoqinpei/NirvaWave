function tr=beam_generation(W0,Y,Z,Beamtype,steering_angle,focal,freq,varargin)
    W0 = W0*1e-3;
    c =  physconst('LightSpeed');
    lambda = c./freq;
    dy = abs(Y(1) - Y(2));
    res = length(Y);
    z_res = abs(Z(2) - Z(1));
    z_length = length(Z);
    %% Transfer Function Equation
    tr = Wavefront_Structure(Beamtype,Y,lambda,W0,focal,varargin);
    %% Apply Phase Shift for Beam Steering
    tr = Steering_Weight(freq,tr,Y,W0,dy,steering_angle,Beamtype,focal);
    %tr = steering2(freq,Y,W0,steering_angle,-steering_angle);
end