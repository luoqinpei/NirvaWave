function E_final=org_propagation(zmax,L,Y,Z,res,z_res,freq,Y_bound,spatial_freq_theta,E,obj_list)
    c =  physconst('LightSpeed');
    lambda = c./freq;
    dy = abs(Y(1) - Y(2));
    res = length(Y);
    z_res = abs(Z(2) - Z(1));
    z_length = length(Z);
    obj_size = size(obj_list);
    obj_length = obj_size(1);
    M = ones(res,z_length);
    for i=1:obj_length
        Ry_p = obj_list(i,1);
        Rx_p = obj_list(i,2);
        RL = obj_list(i,3);
        thickness = obj_list(i,4);
        theta = obj_list(i,5);
        if (Rx_p>=0) && (Rx_p<=zmax)
            M2 = ref_OB(Z,Y,[Ry_p,Rx_p],deg2rad(theta),RL,thickness,zmax,2*Y_bound);
            M = M2.*M;
        end
    end
    H = prop_RS_channel_g(res, L, freq, z_res,deg2rad(spatial_freq_theta));
    E_maxtrix = zeros(res,z_length);
    filter = tukeywin(res, 0.2);
    E = E.*M(:,1).*filter;
    E_maxtrix(:,1) = E;  
    for i = 2:z_length
        E = M(:,i).*prop_RS_cal(E, H).*filter;
        E_maxtrix(:,i) = E;
    end
    E_final = E_maxtrix(res*0.1+1:res*0.9,:);
end 