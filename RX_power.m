function received_power = RX_power(E_matrix,RX_list,RX_files,Y,Z)
    received_power = [];
    length_RX = size(RX_list, 1);
    for i=1:length_RX
        Ry = RX_list(i,1);
        Rx = RX_list(i,2);
        RL = RX_list(i,3);
        theta = RX_list(i,4);
        RX_mode = RX_list(i,5);
        RX_file = RX_files(i);
        elements = RX_list(i,6);
        E_recieved = E_ref(E_matrix,[Ry,Rx],deg2rad(theta),RL,Y,Z);
        num_elements = length(E_recieved);
        assert(elements < num_elements , 'Low Resolution (the resolution and the number of Rx array elements are incompatible).');
        partition_size = floor(num_elements/ elements);
        
        E_recieved_m = zeros(elements,1);
        for i = 1:elements
            start_idx = (i-1) * partition_size + 1;
            if i == elements
                end_idx = num_elements;
            else
                end_idx = i * partition_size;
            end
            
            E_recieved_m(i) = mean(E_recieved(start_idx:end_idx));
        end
        if RX_mode==1
            RX_phase_shift = readmatrix(RX_file);
            assert(elements ~= length(RX_phase_shift), 'Number of RX elements and number of phase shift provided should be the same.');
            indices = round(linspace(1, length(RX_phase_shift), elements));
            Rx_phase = RX_phase_shift;
            E_recieved_m = E_recieved_m .* exp(1i * Rx_phase');
            received_power = [received_power,mag2db(abs(sum(E_recieved_m)).^2)];
        else
            received_power = [received_power,mag2db(sum(abs(E_recieved_m).^2))];
        end
        
    end
    disp(received_power)
end