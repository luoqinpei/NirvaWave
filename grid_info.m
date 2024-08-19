function [Yp,Zp] = grid_info(dimension,Z_length_p,freq)
    zmin = 0.001;
    zmax = dimension*2;
    z_length = Z_length_p*2;
    res = z_length*1.25;
    freq = freq*1e9; 
    Y_bound = zmax/2*1.25;
    [L,Y,Z,res] = Grid_Creation(freq,zmin,zmax,z_length,Y_bound,res);
    Y2 = Y(res*0.1+1:res*0.9,:);
    Yp = Y2(z_length/4+1:z_length*3/4,:);
    Zp = Z(:,1:z_length/2);
end