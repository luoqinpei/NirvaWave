
function E_maxtrix = BeamReflectionD(E,M,H,freq,Y,Z)
    %% Fixed settings
%     E0= 1;
    WF_gen = 'Rayleigh_mode';
    %WF_gen = 'fresnel_mode';
    %% Source
    Source = "Planar";
    %Source = "Gaussian";
    %% Do Not Touch
    %z0 = Z(1);
    c =  physconst('LightSpeed');
    lambda = c./freq;
    %k = (2*pi)/lambda;
    dy = abs(Y(1) - Y(2));
    res = length(Y);
    z_res = abs(Z(2) - Z(1));

    z_length = length(Z);

    %% Check that Fresnel Condition is being fullfilled
    if(strcmp(WF_gen,'fresnel_mode'))
        zcondition = (res*(dy)^2)/lambda;
        if (z_res <= zcondition)
            disp('Fresnel Condition Step Size Fullfilled')
        else
            disp('Fresnel Condition Step Size Not Fullfilled')
            return
        end
    end
    %% Determine Source Type and Configure Array
    E_maxtrix = zeros(res,z_length);
    filter = tukeywin(res, 0.2);
    E = E.*M(:,1).*filter;
    E_maxtrix(:,1) = E;
    %% Generate Wavefronts    
    for i = 2:z_length
        E = M(:,i).*prop_RS_cal(E, H).*filter;
        E_maxtrix(:,i) = E;
    end
end









