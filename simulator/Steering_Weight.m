function tr = Steering_Weight(freq,tr,Y,W0,dy,steering_angle,Beamtype,focal)
    [~,Array_up] = min(abs((Y - W0/2)));
    [~,Array_down] = min(abs((Y - (-W0/2))));
    if(~strcmp(Beamtype,"Gaussian")&&~strcmp(Beamtype,"Bessel"))
        disp(focal);
        array_res = abs(Array_down - Array_up);
        W = FocusedSteeringVector(freq,steering_angle,dy,array_res+1,focal);
    elseif(strcmp(Beamtype,"Gaussian"))
        c =  physconst('LightSpeed');
        lambda = c./freq;
        W = steervec(Y(Array_down:Array_up)'/lambda,[steering_angle;0]);
    end
    if (strcmp(Beamtype,"Bessel"))
        tr(Array_down:Array_up) = tr(Array_down:Array_up).*1;
    else
        tr(Array_down:Array_up) = tr(Array_down:Array_up).*W;
    end
    
end