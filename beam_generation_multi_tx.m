function tr = beam_generation_multi_tx(Y,Z,tx_list,tx_list_beam,freq)

    c =  physconst('LightSpeed');
    lambda = c./freq;
    dy = abs(Y(1) - Y(2));
    space = " ";
    k = 2*pi/lambda;

    tr = zeros(size(Y));
    tx_lenght = size(tx_list,1);
    for i=1:tx_lenght
        W0 = tx_list(i,2)*1e-3;
        location_tx = tx_list(i,1);
        Beamtype = tx_list_beam(i);
        steering_angle = tx_list(i,3);
        focal = tx_list(i,4);
        b = tx_list(i,5);
        theta_s = tx_list(i,6);
        top_limit1 = location_tx + W0/2;
        bottom_limit1 = location_tx - W0/2;
        [~,top_idx1] = min(abs(top_limit1 - Y));
        [~,bottom_idx1] = min(abs(bottom_limit1 - Y));
        
        if(strcmp(Beamtype,'Bessel'))
            disp('Bessel');
            W1 = exp(-1i*k.*abs(Y(bottom_idx1:top_idx1)-location_tx).*sin(deg2rad(theta_s)));
        elseif(strcmp(Beamtype,'Gaussian'))
            W1 = ones(size(Y(bottom_idx1:top_idx1)));
        elseif(strcmp(Beamtype,'Gaussian_BFocusing'))
            disp(strcat("Focal Point = ", num2str(focal),space, "m"))
            W1 = ones(size(Y(bottom_idx1:top_idx1)));
        elseif(strcmp(Beamtype,'Airy'))
            disp("Airy");
            c_ = (2*pi*b)^3; 
            cubic = (1/3)*c_*((Y(bottom_idx1:top_idx1)-location_tx).^3);
            W1 = exp(1i*(cubic));
        end

        if(~strcmp(Beamtype,"Gaussian")&&~strcmp(Beamtype,"Bessel"))
            disp(focal);
            array_res = abs(bottom_idx1 - top_idx1);
            W2 = FocusedSteeringVector(freq,steering_angle,dy,array_res+1,focal);
        elseif(strcmp(Beamtype,"Gaussian"))
            c =  physconst('LightSpeed');
            lambda = c./freq;
            W2 = steervec((Y(bottom_idx1:top_idx1)-location_tx)'/lambda,[steering_angle;0]);
        end
        if (strcmp(Beamtype,"Bessel"))
            tr(bottom_idx1:top_idx1) = W1;
        else
            tr(bottom_idx1:top_idx1) = W1.*W2;
        end
    end

end