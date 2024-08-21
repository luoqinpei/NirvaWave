function object_list_u = transform_obj(ref,obj_list,mirror)
    object_list_u = obj_list;
    obj_size = size(obj_list);
    obj_length = obj_size(1);
    Ry_r = ref(1);
    Rx_r = ref(2);
    theta_r = ref(5);
    for i=1:obj_length
        Ry_p = obj_list(i,1);
        Rx_p = obj_list(i,2);
        RL = obj_list(i,3);
        thickness = obj_list(i,4);
        theta = obj_list(i,5);
        power_ref = obj_list(i,6);
        theta_p = obj_list(i,7);
        hrms = obj_list(i,8);
        Lc = obj_list(i,9);
        RIS_mode = obj_list(i,10);
        if mirror==false
            theta_R = deg2rad(theta_r)+pi/2;
            R = [cos(theta_R), -sin(theta_R); sin(theta_R), cos(theta_R)];
            thetaT = theta - 90 - theta_r;
            if thetaT<-90
                thetaT = -abs(thetaT)+180;
            end
            loc = R*([Rx_p;Ry_p]-[Rx_r;Ry_r]);
            object_list_u(i,:) = [loc(2),loc(1),RL,thickness,thetaT,power_ref,theta_p,hrms,Lc,RIS_mode];
            % if loc(1)<0
            %     object_list_u(i,:) = [];
            % end
        else
            theta_R = deg2rad(theta_r)-pi/2;
            R = [cos(theta_R), -sin(theta_R); sin(theta_R), cos(theta_R)];
            thetaT = -theta + theta_r+90;
            loc = R*([Rx_p;Ry_p]-[Rx_r;Ry_r]);
            if thetaT>90
                thetaT = thetaT-180;
            % elseif thetaT<-90
            %     thetaT = -abs(thetaT)+180;
            end
            object_list_u(i,:) = [-loc(2),loc(1),RL,thickness,thetaT,power_ref,theta_p,hrms,Lc,RIS_mode];
            % if loc(1)<0
            %     object_list_u(i,:) = [];
            % end
        end
        
    end
end