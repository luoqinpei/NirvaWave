function E_final = total_propagation(zmax,L,Y,Z,Zm,res,z_res,freq,Y_bound,Ep,obj_list,theta_spatial_freq,first_run,ref_cond,RIS_files) 
        obj_list_f = obj_list;
        if first_run == false
            obj_list_f(end,:) = [];
        end
        E_f = org_propagation(zmax,L,Y,Z,res,z_res,freq,Y_bound,theta_spatial_freq,Ep,obj_list_f);
        E_final = [zeros(size(E_f)),E_f];
        obj_size = size(obj_list_f);
        obj_length = obj_size(1);
        Y2 = Y(res*0.1+1:res*0.9,:);
        if ref_cond<3
        for i=1:obj_length
            Ry_p = obj_list(i,1);
            Rx_p = obj_list(i,2);
            if Rx_p>0&&Rx_p<2
            RL = obj_list(i,3);
            thickness = obj_list(i,4);
            theta = obj_list(i,5);
            power_ref = obj_list(i,6);
            theta_p = obj_list(i,7);
            hrms = obj_list(i,8);
            Lc = obj_list(i,9);
            RIS_mode = obj_list(i,10);
            RIS_phase_file = RIS_files(i);
            eps_m = 2*z_res;
            for C=1:2
                mirror=false;
                if C==1
                    Rx = Rx_p;
                    Ry = Ry_p;
                    tx = Rx;
                    ty = Ry;
                    thetaR = deg2rad(theta)+pi/2; 
                    E_reflected = E_ref(E_f,[Ry-eps_m*cos(deg2rad(theta)),Rx-eps_m*sin(deg2rad(theta))],deg2rad(theta),RL,Y2,Z);
                    obj_list_u = obj_list;
                    Tx_ref_obj = obj_list(i,:);
                    obj_list_u(i,:) = [];
                    obj_list_u = [obj_list_u;Tx_ref_obj];
                    obj_list_u = transform_obj(obj_list(i,:),obj_list_u,mirror);
                    RIS_files_u = RIS_files;
                    RIS_files_u(i) = [];
                    if isempty(RIS_files_u)
                        RIS_files_u = [RIS_phase_file];
                    else
                        RIS_files_u = [RIS_files_u;RIS_phase_file];
                    end
                else
                    Rx = Rx_p + thickness*sin(deg2rad(theta));
                    Ry = Ry_p + thickness*cos(deg2rad(theta));
                    thetaR = deg2rad(theta)-pi/2;
                    mirror=true;
                    tx = Rx;
                    ty = Ry;
                    E_reflected = E_ref(E_f,[Ry+eps_m*cos(deg2rad(theta)),Rx+eps_m*sin(deg2rad(theta))],deg2rad(theta),RL,Y2,Z);
                    obj_list_u = obj_list;
                    Tx_ref_obj = obj_list(i,:);
                    obj_list_u(i,:) = [];
                    obj_list_u = [obj_list_u;Tx_ref_obj];
                    obj_list_u = transform_obj(obj_list(i,:),obj_list_u,mirror);
                    RIS_files_u = RIS_files;
                    RIS_files_u(i) = [];
                    if isempty(RIS_files_u)
                        RIS_files_u = [RIS_phase_file];
                    else
                        RIS_files_u = [RIS_files_u;RIS_phase_file];
                    end
                end
                
                if abs(theta_p)<=45
                    thetaX = abs(theta_p);
                else
                    thetaX = 90-abs(theta_p);  
                end
                t = "ref cond= "+num2str(ref_cond)+", c= "+ num2str(C)+", i= "+num2str(i);
                E_reflected = E_reflected.*power_ref;
                num_elements = length(E_reflected);
                lambda = 3*10^8/freq;
                random_phases = phase_shift_r(hrms,Lc,RL*1000,num_elements,lambda);
                E_reflected = E_reflected .* exp(1i * random_phases);
                if RIS_mode==1
                    f = readmatrix(RIS_phase_file);
                    RIS_phase_shift = 2*pi.*f/lambda/1000;
                    assert(num_elements <= length(RIS_phase_shift), 'Not enough phase elements have been specified');
                    indices = round(linspace(1, length(RIS_phase_shift), num_elements));
                    RIS_phase = RIS_phase_shift(indices);
                    E_reflected = E_reflected .* exp(1i * RIS_phase');
                end
                E_reflected_plane = zeros(res,1);
                E_reflected_plane(floor(res/2)-length(E_reflected)/2:floor(res/2)+length(E_reflected)/2-1)...
                    = E_reflected;
                reflected_power = mag2db(sum(abs(E_reflected)));
                if reflected_power>=0
                    E_m = total_propagation(zmax,L,Y,Z,Zm,res,z_res,freq,Y_bound,E_reflected_plane,obj_list_u,thetaX,false,ref_cond+1,RIS_files_u);
                else
                    E_m = zeros(length(Y2),2*length(Z));
                end
                E_transformed = transforam_cord(Zm,Y2,E_m,thetaR,tx,ty,mirror);
                
                E_final = (E_transformed)+(E_final);
            end
            end
        end
        end
end