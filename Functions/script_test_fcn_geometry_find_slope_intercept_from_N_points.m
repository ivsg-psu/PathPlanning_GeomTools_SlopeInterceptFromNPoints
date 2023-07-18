% script_test_fcn_geometry_find_phi_rho_from_two_polar_coords
% Exercises the function: fcn_geometry_find_slope_intercept_from_N_points

% Revision history:
% 2020_06_25 
% -- wrote the code
% 2023_07_18 - Sean Brennan, sbrennan@psu.edu
% -- better comments, reorganization

close all;
clc;


%% Simplest example
points = [2 3; 4 5];
[slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points);
fprintf(1,'Slope is: %.2f, Intercept is: %.2f\n',slope,intercept);


%% Example 1: a basic test of the figure using simplest example
fig_num = 1;
points = [2 3; 4 5];
[slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points,fig_num);
fprintf(1,'Slope is: %.2f, Intercept is: %.2f\n',slope,intercept);


%% Example 2: many points randomly determined
fig_num = 2;
slope = 3;
intercept = 4;

Npoints = 1000;
x_data = linspace(-2,5,Npoints)';
y_data = x_data*slope + intercept + intercept*0.2*randn(Npoints,1);
points = [x_data,y_data];

[slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points,fig_num);
fprintf(1,'Slope is: %.2f, Intercept is: %.2f\n',slope,intercept);

%% Example 3: a vertical line
fig_num = 3;
points = [2 0; 2 2];
[slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points,fig_num);
fprintf(1,'Slope is: %.2f, Intercept is: %.2f\n',slope,intercept);

%% Test 4: many vertical points
fig_num = fig_num + 1;

Npoints = 1000;
x_data = 2*ones(Npoints,1);
y_data = linspace(-1,10,Npoints)';
points = [x_data,y_data];

[slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points,fig_num);
fprintf(1,'Slope is: %.2f, Intercept is: %.2f\n',slope,intercept);

%% Test 5: Test a singular situation (determinant is zero - which gives b = 0)
% The A matrix is singular, but should still generate an answer.
fig_num = fig_num + 1;
points = [6 4; 3 2];
[slope,intercept] = fcn_geometry_find_slope_intercept_from_N_points(points,fig_num);
fprintf(1,'Slope is: %.2f, Intercept is: %.2f\n',slope,intercept);
