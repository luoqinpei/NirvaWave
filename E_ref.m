function E_temp = E_ref(E,Ref_loc,theta,L,Y,Z)
    [~, ref_mid_z] = min(abs(Ref_loc(2)- Z));
    [~, ref_mid_y] = min(abs(Ref_loc(1)- Y));
    [~, ref_top_z] = min(abs(Ref_loc(2)+L*cos(theta)/2- Z));
    [~, ref_top_y] = min(abs(Ref_loc(1)-L*sin(theta)/2- Y));
    [~, ref_bot_z] = min(abs(Ref_loc(2)-L*cos(theta)/2- Z));
    [~, ref_bot_y] = min(abs(Ref_loc(1)+L*sin(theta)/2- Y));
    delta_Y = ref_top_y-ref_bot_y;
    delta_Z = ref_top_z-ref_bot_z;
    E_res = max(abs(delta_Y),abs(delta_Z));
    E_temp = zeros(E_res+1,1);
    E_temp(1) = E(ref_bot_y,ref_bot_z);
    if abs(delta_Y)>=abs(delta_Z)
        if abs(delta_Z)<1e-10
            for i=1:abs(delta_Y)
                if(theta>=0)
                    E_temp(i+1) = E(ref_bot_y-i,ref_mid_z);
                else
                    E_temp(i+1) = E(ref_bot_y+i,ref_mid_z);
                end
            end
        else
         step = (abs(delta_Y)/abs(delta_Z));
         for i=1:abs(delta_Y)
             if(theta>=0)
                E_temp(i+1) = E(ref_bot_y-i,ref_bot_z+floor(i/step));
             else
                E_temp(i+1) = E(ref_bot_y+i,ref_bot_z+floor(i/step));
             end
         end
        end
    else
        if abs(delta_Y)<1e-10
            for i=1:abs(delta_Z)
             E_temp(i+1) = E(ref_mid_y,ref_bot_z+i);
            end
        else
         step = (abs(delta_Z)/abs(delta_Y));
         for i=1:abs(delta_Z)
             if(theta>=0)
               E_temp(i+1) = E(ref_bot_y-floor(i/step),ref_bot_z+i);
             else
                E_temp(i+1) = E(ref_bot_y+floor(i/step),ref_bot_z+i);
             end
         end
        end
    end
end