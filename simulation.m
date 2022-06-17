%% a simulation of gyroscope precession and nutation, based on the idea of the whole gyroscope motion as a combination of precession and nutation about different axis. Input parameters here are arbitrary.
%% to restart workspace and clear figures
clear all
close all
clc

%% To define parameters, initial coordinates of shapes, rotation matrices
r = 3; % radius of rotor (disc of gyroscope)
h = 0.5; % height of the rotor
n = 30; % number of points sampled around the rotor
L = 15; % distance from lower tip of gyroscope to the bottom of gyroscope rotor

b0 = 0;
a0 = pi/24; %initial angle with Z
%a is theta b is phi
% a and b are for the 1st set of rotations, which will be nutation
c0 = pi/12;
d0 = 0;

[Xi, Yi, Zi] = cylinder(r, n);
Zi = Zi*h +L;
Xtop = 0;
Ytop = 0;
Ztop = Zi(2,1) + L/2; % for drawing the axis of gyroscope

R_ny = [cos(a0) 0 -sin(a0); 0 1 0; sin(a0) 0 cos(a0)]; % nutation
R_py = [cos(c0) 0 -sin(c0); 0 1 0; sin(c0) 0 cos(c0)];
% rotate the gyroscope axis around y axis by angle a (=theta)
[X_phi0, Y_phi0, Z_phi0] = rotation(Xi, Yi, Zi, R_ny);
[Xtop, Ytop, Ztop] = rotation(Xtop, Ytop, Ztop, R_ny);
% when phi angle = 0

%% To draw gyroscope motion in time

for t= pi:pi/60:8*pi
    b = b0 + 5*t;
    d = d0 + 1.5*t;
    R_pz = [cos(d) -sin(d) 0; sin(d) cos(d) 0; 0 0 1];
    R_nz = [cos(b) -sin(b) 0; sin(b) cos(b) 0; 0 0 1];
    % rotation matrix around z axis by angle b (=phi)
    [X, Y, Z] = rotation(X_phi0, Y_phi0, Z_phi0, R_nz);
    [Xtopr, Ytopr, Ztopr] = rotation(Xtop, Ytop, Ztop, R_nz);
    % to rotate the axis (already tilted at angle theta) around z by an
    % angle of phi
    % thus obtains nutation without precession
    % use Xtopr for rotated coordinate of the top tip of gyroscope axis
    
    [X, Y, Z] = rotation(X, Y, Z, R_py);
    [Xtopr, Ytopr, Ztopr] = rotation(Xtopr, Ytopr, Ztopr, R_py);
    [X, Y, Z] = rotation(X, Y, Z, R_pz);
    [Xtopr, Ytopr, Ztopr] = rotation(Xtopr, Ytopr, Ztopr, R_pz);
    axis = [0 0 0; Xtopr Ytopr Ztopr];

    surf(X, Y, Z, 'FaceColor','b');
    hold on
    % not sure why, but the position of "hold on" in this whole bunch of
    % drawing commands matters
    plot3(0,0,0,'*-b'); % marks the origin
    fill3(X(1,:), Y(1,:), Z(1,:),'b');
    fill3(X(2,:), Y(2,:), Z(2,:),'b');
    plot3(axis(:,1), axis(:,2), axis(:,3), 'LineWidth',3);

    pbaspect([1 1 1]) % plotbox aspect ratio
    set(gca,'xlim',[-15 15],'ylim',[-15 15], 'ZLim', [0 30]);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    hold off

    drawnow
    % pause(0.1);
end

%% To define rotation function

function [xf,yf,zf]=rotation(xi,yi,zi,R) 
%definition of rotation function. xi = initial x, R = rotation matrix
%code from Toplizhuo
I=size(xi,1);
J=size(xi,2);
 
xf=zeros(I,J);
yf=zeros(I,J);
zf=zeros(I,J);
 
for ii=1:I
	for jj=1:J
    	vector=[xi(ii,jj);yi(ii,jj);zi(ii,jj)];
    	vector=R*vector;
        	xf(ii,jj)=vector(1);
        	yf(ii,jj)=vector(2);
        	zf(ii,jj)=vector(3);
	end
end
end
