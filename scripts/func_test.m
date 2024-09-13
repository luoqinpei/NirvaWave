close all
clear all
clc
addpath("../simulator/")
%% input parameters
% For simulating Env. with D dimenssions: zmax = 2D and Y_bound = 1.25*D
zmin = 0.001;
zmax = 2;
Y_bound =1.25;
z_length = 4000; %2*Resolution
res = 5000; %2.5*Resolution
freq = 100;
B_d = 4.5;
focal = 0.15;
steering_angle = 45;
theta_s = 5;
W0 = 60; %in mm
Beamtype = 'Gaussian';
%Beamtype = 'Airy';
%Beamtype = 'Bessel';
%Beamtype = 'Gaussian_BFocusing';
Rx_p = 0.25;
Ry_p = 0.25;
RL = 0.2; 
theta = 0; 
thickness = 0.02;
%% Do not touch 
freq = freq*1e9; 
%% coordinates points and source creation
[L,Y,Z,res] = Grid_Creation(freq,zmin,zmax,z_length,Y_bound,res);
Zm = linspace(-zmax,zmax,2*z_length);
z_res = Z(2)-Z(1);
E0 = 1;
E = Source_Gen(Beamtype,'Planar',E0,res,zmin,W0,Y);
tr = beam_generation(W0,Y,Z,Beamtype,steering_angle,focal,freq,B_d,theta_s);
E = tr.*E;
%% Object Properties List
RIS_files = ["../examples/RIS_non_specular.txt"];
%obj_list = [object_loc Y, object_loc X, length, thickness, orientaion, reflection_power, orientation, h_rms, L_c, RIS_mode]
%obj_list = [0,0.5,RL,thickness,0,1,0,0,10,0;-0.25,0.7,RL,thickness,90,1,90,0,10,0;Ry_p,Rx_p,RL,thickness,theta,1,theta,0,10,0];
%obj_list = [Ry_p,Rx_p,RL,thickness,theta,1,theta,0,3,0;0,0.5,RL,thickness,theta,1,theta,0,3,0];
obj_list = [Ry_p,Rx_p,RL,thickness,theta,1,theta,0,3,1];
%obj_list = [];
%E_f = org_propagation(zmax,L,Y,Z,res,z_res,freq,Y_bound,0,E,obj_list);
E_f = total_propagation(zmax,L,Y,Z,Zm,res,z_res,freq,Y_bound,E,obj_list,0,true,0,RIS_files);
Y2 = Y(0.1*res+1:0.9*res,:);
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
clim([-90 0]);
ax = gca;
