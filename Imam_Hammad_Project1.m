%Hammad Imam // himam@iastate.edu
%AER_E 161 Project 1
%February 23rd, 2018
clear, clc;

%initial values for each variable
h_g = 0;
T = 288.16;
d = 1.225;
p = 101325;

%constants/etc that will be used in calculations
a_t = -6.5*10^-3;
a_s = 3*10^-3;
r_e = 6371.0003;
g = 9.80065;
R = 287;

%string names to associate with each variable (g - graph, t - table)
G_h = 'Geopotential Altitude (km)'; T_h = 'Geopotential';
G_g = 'Geometric Altitude (km)'; T_g = 'Geometric';
G_T = 'Temperature (K)'; T_T = 'Temperature';
G_d = 'Density (kg/m^3)'; T_d = 'Density';
G_p = 'Pressure (N/m^2)'; T_p = 'Pressure';

%initialize resulting matrix to first row, initial values
res = [0,h_g,T,d,p;];

for h = 1:47
    
   if(h<=11)        %if under height of troposphere
       a = a_t;     %use the troposphere a value
   elseif(h<25)     %elseif above troposphere, but under stratosphere
       a = 0;       %set a to 0 (to be used for checking later)
   else             %else, not under stratosphere, must be in it
       a = a_s;     %use the stratosphere a value
   end
   
   T_0 = res(h,3);  %set the initial temp to the one above current row
   d_0 = res(h,4);  %same for density
   p_0 = res(h,5);  %same for pressure 
   
   h_g = (r_e*h)/(r_e - h);     %calculate geometric from geopotential
   T = T_0 + (a*1000);          %calculate temp from previous temp, a
   
   if(a == 0)                               %if in isothermal zone 
       d = d_0 * exp((-g/(R*T))*1000);      %use isothermal density calc
       p = p_0 * exp((-g/(R*T))*1000);      %same for pressure
   else                                     %else, is in gradient layer
       d = d_0 * ((T/T_0)^((-g/(a*R))-1));  %use gradient density calc
       p = p_0 * ((T/T_0)^(-g/(a*R)));      %same for pressure
   end
   
   res(h+1,1:end) = [h,h_g,T,d,p];  %add a matrix row with those values
end

%Standard Atmosphere Table
disp('Standard Atmosphere Table');
disp(array2table(res,'VariableNames',{T_h,T_g,T_T,T_d,T_p}));

%Geopotential Height vs Temperature
figure
plot(res(1:end, 1), res(1:end, 3),'.b-')
xlabel(G_h);
ylabel(G_T);
title([G_T, ' vs. ', G_h])

%Geopotential Height vs Density
figure
plot(res(1:end, 1), res(1:end, 4),'.r-')
xlabel(G_h);
ylabel(G_d);
title([G_d, ' vs. ', G_h])

%Geopotential Height vs Pressure
figure
plot(res(1:end, 1), res(1:end, 5),'.g-')
xlabel(G_h);
ylabel(G_p);
title([G_p, ' vs. ', G_h])

%fin