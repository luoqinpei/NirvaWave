close all
clear all
clc
maxNumCompThreads(48);
zmin = 0.001;
zmax = 2;
z_length = 4000;
res = 5000;
freq = 100;
B_d = -4.5; 
focal = 0.15;
steering_angle = 0;
theta_s = 5;
W0 = 60; %in mm
Beamtype = 'Gaussian';
%Beamtype = 'Airy';
%Beamtype = 'Bessel';
%Beamtype = 'Gaussian_BFocusing';
M_par = [0.2,0,.2,.1];
Y_bound =1.25;
OBA = false;
E0 = 1;
Rx_p = 0.5;
Ry_p = 0;
RL = 0.1; 
theta = 45; 
thickness = 0.01;
%% Do not touch 
freq = freq*1e9; 
%% coordinates points and source creation
[L,Y,Z,res] = Grid_Creation(freq,zmin,zmax,z_length,Y_bound,res);
Zm = linspace(-zmax,zmax,2*z_length);
z_res = Z(2)-Z(1);
E = Source_Gen(Beamtype,'Planar',E0,res,zmin,W0,Y);
tr = beam_generation(W0,Y,Z,Beamtype,steering_angle,focal,freq,B_d,theta_s);
E = tr.*E;
phi_max = pi/2;
RIS_phase = (rand(1, 350) * 2 * phi_max) - phi_max;
writematrix(RIS_phase,'RIS_phase.txt');
%obj_list = [Ry_p,Rx_p,RL,thickness,theta,1,theta,0,10,0;-0.3,0.5,RL,thickness,0,1,0,0,10,0];
RIS_files = ["rough_surf_0.5.txt"];
%obj_list = [0,0.5,RL,thickness,0,1,0,0,10,0;-0.25,0.7,RL,thickness,90,1,90,0,10,0;Ry_p,Rx_p,RL,thickness,theta,1,theta,0,10,0];
%obj_list = [Ry_p,Rx_p,RL,thickness,theta,1,theta,0,3,0;0,0.5,RL,thickness,theta,1,theta,0,3,0];
obj_list = [Ry_p,Rx_p,RL,thickness,theta,1,theta,0,3,1];
%obj_list = [];
%E_f = org_propagation(zmax,L,Y,Z,res,z_res,freq,Y_bound,0,E,obj_list);
dummy = [0,0,1,1,0,0,0];
E_f = total_propagation(zmax,L,Y,Z,Zm,res,z_res,freq,Y_bound,E,obj_list,0,true,0,RIS_files);
Y2 = Y(501:4500,:);
E_final_p = E_f(z_length/4+1:z_length*3/4,z_length+1:z_length*3/2);
E_sim_final = imresize(E_final_p, [200, 200],'nearest');
E_norm_final = E_sim_final./max(abs(E_sim_final(:)));
file_name = "test.txt";
%writematrix(E_norm_final,file_name);
Yp = Y2(z_length/4+1:z_length*3/4,:);
Zp = Z(:,1:z_length/2);

figure;
imagesc(Zp,Yp,mag2db(abs(E_final_p./(max(E_final_p(:))))));
colorbar
%colormap('hot');
clim([-120 0]);
ax = gca;
figure;
imagesc(mag2db(abs(E_sim_final./(max(E_sim_final(:))))));
colorbar
%colormap('hot');
clim([-120 0])