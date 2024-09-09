function E_matrix = near_field_propagation(freq,dimension,Z_length_p,theta_s,B_d,focal,steering_angle,W0,Beamtype,obj_list,RIS_files,E_field_file,tx_list,tx_list_beam,E_mode)
    disp("Start Running the Simulation");
    zmin = 0.001;
    zmax = dimension*2;
    z_length = Z_length_p*2;
    res = round(z_length*1.25);
    freq = freq*1e9; 
    Y_bound = zmax/2*1.25;
    [L,Y,Z,res] = Grid_Creation(freq,zmin,zmax,z_length,Y_bound,res);
    Zm = linspace(-zmax,zmax,2*z_length);
    z_res = Z(2)-Z(1);
    if E_mode==1
        E_matrix_p = readmatrix(E_field_file);
        N = Z_length_p;
        E = zeros(res,1);
        startIdx = floor((res - N) / 2);
        E(startIdx+1:startIdx + N) = E_matrix_p;
    elseif E_mode==2
        E = Source_Gen(Beamtype,'Planar',1,res,zmin,W0,Y);
        tr = beam_generation_multi_tx(Y,Z,tx_list,tx_list_beam,freq);
        E = tr.*E;
    else
        E = Source_Gen(Beamtype,'Planar',1,res,zmin,W0,Y);
        tr = beam_generation(W0,Y,Z,Beamtype,steering_angle,focal,freq,B_d,theta_s);
        E = tr.*E;
    end

    E_f = total_propagation(zmax,L,Y,Z,Zm,res,z_res,freq,Y_bound,E,obj_list,0,true,0,RIS_files);
    Y2 = Y(res*0.1+1:res*0.9,:);
    E_matrix = E_f(z_length/4+1:z_length*3/4,z_length+1:z_length*3/2);
    Yp = Y2(z_length/4+1:z_length*3/4,:);
    Zp = Z(:,1:z_length/2);
    disp("Simulation is Done");
end