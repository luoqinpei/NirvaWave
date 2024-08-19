function M = ref_OB(Z,Y,Ref_loc,theta,L,t,len_z,len_y)
    M = ones(length(Y),length(Z));
    [~, ref_mid_z] = min(abs(Ref_loc(2)- Z));
    [~, ref_mid_y] = min(abs(Ref_loc(1)- Y));
    [~, ref_top_z] = min(abs(Ref_loc(2)+L*cos(theta)/2- Z));
    [~, ref_top_y] = min(abs(Ref_loc(1)-L*sin(theta)/2- Y));
    [~, ref_bot_z] = min(abs(Ref_loc(2)-L*cos(theta)/2- Z));
    [~, ref_bot_y] = min(abs(Ref_loc(1)+L*sin(theta)/2- Y));
    tickness_Z = abs(floor(t*length(Z)*sin(theta)/len_z));
    tickness_Y = abs(floor(t*length(Y)*sin(pi/2-theta)/len_y));
    % ref_mid_z = ref_mid_z +1;
    % ref_mid_y = ref_mid_y +1;
    % ref_top_z = ref_top_z +1;
    % ref_top_y = ref_top_y +1;
    % ref_bot_z = ref_bot_z +1;
    % ref_bot_y = ref_bot_y +1;
    att = 0.5;

    delta_Y = ref_top_y-ref_bot_y;
    delta_Z = ref_top_z-ref_bot_z;
    if abs(delta_Y)>=abs(delta_Z)
        if abs(delta_Z)<1e-10
            for i=1:abs(delta_Y)
                if(theta>=0)
                    if ref_mid_z+tickness_Z > length(Z)
                        M(ref_bot_y-i:ref_bot_y-i+tickness_Y,ref_mid_z:length(Z)) = att;
                    else
                        M(ref_bot_y-i:ref_bot_y-i+tickness_Y,ref_mid_z:ref_mid_z+tickness_Z) = att;
                    end
                     
                else 
                    if ref_mid_z-tickness_Z < 1
                        M(ref_bot_y+i:ref_bot_y+i+tickness_Y,1:ref_mid_z) = att;
                    else
                        M(ref_bot_y+i:ref_bot_y+i+tickness_Y,ref_mid_z-tickness_Z:ref_mid_z) = att;
                    end
                end
            end
        else
         step = (abs(delta_Y)/abs(delta_Z));
         for i=1:abs(delta_Y)
             if(theta>=0)
                if ref_bot_z+floor(i/step)+tickness_Z > length(Z)
                    M(ref_bot_y-i:ref_bot_y-i+tickness_Y,ref_bot_z+floor(i/step):length(Z))=att;
                else
                    M(ref_bot_y-i:ref_bot_y-i+tickness_Y,ref_bot_z+floor(i/step):ref_bot_z+floor(i/step)+tickness_Z)=att;
                end
             else
                 if ref_bot_z+floor(i/step)-tickness_Z < Z(1)
                     M(ref_bot_y+i:ref_bot_y+i+tickness_Y,1:ref_bot_z+floor(i/step))=att;
                 else
                     M(ref_bot_y+i:ref_bot_y+i+tickness_Y,ref_bot_z+floor(i/step)-tickness_Z:ref_bot_z+floor(i/step))=att;
                 end
             end
         end
        end
    else
        if abs(delta_Y)<1e-10
            for i=1:abs(delta_Z)
                if(theta>=0)
                    if ref_bot_z+i+tickness_Z > length(Z)
                        M(ref_mid_y:ref_mid_y+tickness_Y,ref_bot_z+i:length(Z))=att;
                    else
                        M(ref_mid_y:ref_mid_y+tickness_Y,ref_bot_z+i:ref_bot_z+i+tickness_Z)=att;
                    end
                    
                else
                    if ref_bot_z+i-tickness_Z < 1
                        M(ref_mid_y:ref_mid_y+tickness_Y,1:ref_bot_z+i)=att;
                    else
                        M(ref_mid_y:ref_mid_y+tickness_Y,ref_bot_z+i-tickness_Z:ref_bot_z+i)=att;
                    end
                     
                end
            end
        else
         step = (abs(delta_Z)/abs(delta_Y));
         for i=1:abs(delta_Z)
             if(theta>=0)
                 if ref_bot_z+i+tickness_Z > length(Z)
                     M(ref_bot_y-floor(i/step):ref_bot_y-floor(i/step)+tickness_Y,ref_bot_z+i:length(Z))=att;
                 else
                     M(ref_bot_y-floor(i/step):ref_bot_y-floor(i/step)+tickness_Y,ref_bot_z+i:ref_bot_z+i+tickness_Z)=att;
                 end
                
             else
                 if ref_bot_z+i-tickness_Z < 1
                     M(ref_bot_y+floor(i/step):ref_bot_y+floor(i/step)+tickness_Y,1:ref_bot_z+i)=att;
                 else
                     M(ref_bot_y+floor(i/step):ref_bot_y+floor(i/step)+tickness_Y,ref_bot_z+i-tickness_Z:ref_bot_z+i)=att;
                 end
             end
         end
        end
    end
end
