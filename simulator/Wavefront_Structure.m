function tr = Wavefront_Structure(Beamtype,Y,lambda,W0,focal,varargin)
    if(~isempty(varargin))
        varargin = varargin{1};
    end
    space = " ";
    k = 2*pi/lambda;
    %% Beam Transfer Function
    if(strcmp(Beamtype,'Bessel'))
        theta_s = varargin{2};
        tr = exp(-1i*k.*abs(Y).*sin(deg2rad(theta_s)));
    elseif(strcmp(Beamtype,'Gaussian'))
        tr = ones(size(Y));
    elseif(strcmp(Beamtype,'Gaussian_BFocusing'))
        disp(strcat("Focal Point = ", num2str(focal),space, "m"))
        tr = ones(size(Y));
    elseif(strcmp(Beamtype,'Airy'))
        b = varargin{1};
        c_ = (2*pi*b)^3; 
        cubic = (1/3)*c_*(Y.^3);
        tr = exp(1i*(cubic));
    end


   %% Aperture Selection
   y0 = 0;
   aperture = aperture1D(Y,W0,y0);  
   tr = tr.*aperture;
end